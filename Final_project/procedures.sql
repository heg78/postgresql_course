CREATE OR REPLACE PROCEDURE otus.processing_buffers()
	LANGUAGE plpgsql
AS $procedure$
	declare 
		t_quotes_d quotes_d%rowtype;
	BEGIN
		for t_quotes_d in (
						select sec.id "security", per."time" "time", buf."open", buf.hi, buf.lo, buf."close", buf.volume 
						from buff_quotes_d buf
							left join securities sec on buf.secid=sec.secid 
							left join period_d per on buf ."time" =per."time" 
						where sec.id is not null 
							and per."time" is not null
						)
		loop 
			begin
				insert into quotes_d values(t_quotes_d.*);
			exception
				when UNIQUE_VIOLATION then
					update quotes_d set "open"=t_quotes_d."open" where "security"=t_quotes_d."security" and "time"=t_quotes_d."time";
					RAISE NOTICE 'UPDATED : % , Name is : %', t_quotes_d."security", t_quotes_d.volume;	
			end;
		end loop;
		delete from buff_quotes_d;
	END;
$procedure$

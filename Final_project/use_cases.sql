
create or replace view gazp_day_quotes as
	select s.shortname, date(q."time"), q."open", q.hi, q.lo, q."close", q."volume" from quotes_d q
	join period_d p on q."time"=p."time"
	join securities s on s.id=q."security"
	where s.secid='GAZP'
	order by q."time" ;

create or replace view average_daily_return_by_sercurity as
	select s.secid "security", avg(abs(q."open"-q."close")/q."open"*100) "percent" from quotes_d q
	join period_d p on q."time"=p."time"
	join securities s on s.id=q."security"
	group by s.secid;
	
create or replace view daily_return_by_dow as
	select 
		p.day_of_week "DOW", 
		max(abs(q."open"-q."close")/q."open"*100) "percent, max",
		min(abs(q."open"-q."close")/q."open"*100) "percent, min",
		avg(abs(q."open"-q."close")/q."open"*100) "percent, avg"
	from quotes_d q
	join period_d p on q."time"=p."time"
	join securities s on s.id=q."security"
	group by p.day_of_week;

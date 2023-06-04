CREATE TABLE otus.securities (
	id int4 NOT NULL,
	secid varchar(51) NULL,
	shortname varchar(189) NULL,
	regnumber varchar(189) NULL,
	"name" varchar(765) NULL,
	isin varchar(765) NULL,
	is_traded int4 NULL,
	gosreg varchar(189) NULL,
	"type" varchar(93) NULL,
	"group" varchar(93) NULL,
	primary_boardid varchar(12) NULL,
	marketprice_boardid varchar(12) NULL,
	CONSTRAINT securities_pk PRIMARY KEY (id),
	CONSTRAINT securities_un UNIQUE (secid)
);

INSERT INTO otus.securities
(id, secid, shortname, regnumber, "name", isin, is_traded, gosreg, "type", "group", primary_boardid, marketprice_boardid)
VALUES(1, 'RTSI', 'Индекс РТС', '', 'Индекс РТС', 'RU000A0JPEB3', 1, '', 'stock_index', 'stock_index', 'RTSI', '');

INSERT INTO otus.securities
(id, secid, shortname, regnumber, "name", isin, is_traded, gosreg, "type", "group", primary_boardid, marketprice_boardid)
VALUES(2, 'GAZP', 'ГАЗПРОМ ао', '1-02-00028-A', '"Газпром" (ПАО) ао', 'RU0007661625', 1, '1-02-00028-A', 'common_share', 'stock_shares', 'TQBR', 'TQBR');

CREATE TABLE otus.quotes_d (
	"security" int4 NOT NULL,
	"time" timestamp not NULL,
	"open" numeric(20, 10) NULL,
	hi numeric(20, 10) NULL,
	lo numeric(20, 10) NULL,
	"close" numeric(20, 10) NULL,
	volume numeric(20, 10) NULL,
	CONSTRAINT quotes_d_fk FOREIGN KEY ("security") REFERENCES otus.securities(id),
	constraint quotes_d_fk2 FOREIGN KEY ("time") references otus.period_d("time"),
	CONSTRAINT quotes_d_un UNIQUE ("security","time")
);

create table otus.period_d (
	"time" timestamp not null,
	is_work int4 default 1,
	day_of_week varchar(10) null,
	num_of_week int4 null,
	CONSTRAINT period_d_pk PRIMARY KEY ("time")
); 

insert into period_d("time") SELECT generate_series(timestamp '2000-01-01', '2030-01-01', '1 day');

insert into period_d("time") SELECT generate_series(timestamp '2000-01-01', '2030-01-01', '1 day');
update period_d set day_of_week=trim(to_char(date("time"), 'day'));
update period_d set is_work=0 where day_of_week in ('saturday','sunday');

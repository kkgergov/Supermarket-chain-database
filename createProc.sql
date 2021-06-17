create or replace procedure fire_underperforming()
language sql
as $$
	delete from employee
	where should_be_fired(employeeid);
$$;

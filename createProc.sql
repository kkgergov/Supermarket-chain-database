create or replace procedure update_order_status(ord_id int)
language plpgsql
as $$
begin
	update orders as O
	set status = 'failed'
	where O.order_customerid = (select customerid
							 from customer join payment on customer.customerid = payment.payment_customerid 
							 where payment.paymentid = ord_id and payment.amount > customer.creditlimit);
end
$$;

create or replace procedure fire(emp_id int)
language plpgsql
as $$
begin
	if should_be_fired(emp_id)
	then
		delete from employee
		where employeeid = emp_id;
	else
		RAISE EXCEPTION 'no reason to be fired!';
	end if;
end
$$;

create or replace procedure promote(emp_id int)
language plpgsql
as $$
declare
	boss_id int;
begin
	select reports_to into boss_id
	from employee
	where employeeid = emp_id;
	
	if boss_id is not null
	then
		update employee as e
		set reports_to = (select reports_to from employee where employee.employeeid = boss_id)
		where e.employeeid = emp_id;
	else
		RAISE EXCEPTION 'cannot be promoted!'; 
	end if;
end
$$;
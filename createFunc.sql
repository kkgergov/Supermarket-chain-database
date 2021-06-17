create or replace function num_unsuccessful_orders(emp_id int) returns int as $$
declare
	number_unsuc int;
begin
	select count(*) into number_unsuc
	from customer join orders on customer.customerid = orders.order_customerid
	where customer.customer_employeeid = emp_id and orders.status = 'failed';	
return number_unsuc;
end $$ language plpgsql;


create or replace function num_declined_cards(emp_id int) returns int as $$
declare
	number_dec int;
begin
	select count(*) into number_dec
	from customer join payment on customer.customerid = payment.payment_customerid
	where customer.customer_employeeid = emp_id and payment.amount > customer.creditlimit;	
return number_dec;
end $$ language plpgsql;


create or replace function should_be_fired(emp_id int) returns boolean as $$
declare
	unsuccessful_orders int;
	declined_cards int;
begin
	select * into unsuccessful_orders
	from num_unsuccessful_orders(emp_id);
	
	select * into declined_cards
	from num_declined_cards(emp_id);
	
	if unsuccessful_orders - declined_cards > 1 THEN
		return true;
	else
		return false;
	end if;
end $$ language plpgsql;

--select * from employee where should_be_fired(employeeid);
--select * from num_unsuccessful_orders(1);
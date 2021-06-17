------------------deletes an order and all details associated with it
create or replace function delete_trigger1() returns trigger as $$
begin
	delete from OrderDetails
	where OrderDetails.details_orderid = old.orderid;
	
	return old;
end $$ language plpgsql;

drop trigger if exists before_delete_orders on Orders;
create trigger before_delete_orders
before delete on Orders
for each row
execute procedure delete_trigger1();
------------------deletes customer along with all his orders and payments
create or replace function delete_trigger2() returns trigger as $$
begin
	delete from Payment
	where Payment.payment_customerid = old.customerid;
	--RAISE NOTICE '%', old.customerid;
	delete from Orders
	where Orders.order_customerid = old.customerid;
	
	return old;
end $$ language plpgsql;

drop trigger if exists before_delete_customer on Customer;
create trigger before_delete_customer
before delete on Customer
for each row
execute procedure delete_trigger2();

--------------------------------------------------------
create or replace function delete_trigger3() returns trigger as $$
begin
	update customer
	set customer_employeeid = null
	where customer.customer_employeeid = old.employeeid;
	
	update employee
	set reports_to = old.reports_to
	where reports_to = old.employeeid;
	
	return old;
end $$ language plpgsql;

drop trigger if exists before_delete_employee on employee;
create trigger before_delete_employee
before delete on employee
for each row
execute procedure delete_trigger3();
---------------------------------------------
create or replace function insert_trigger1() returns trigger as $$
begin
	update orders as O
	set status = 'failed'
	where O.order_customerid = (select customerid
							 from customer join payment on customer.customerid = payment.payment_customerid 
							 where payment.paymentid = new.orderid and payment.amount > customer.creditlimit);
	
	return new;
end $$ language plpgsql;

drop trigger if exists after_insert_order on orders;
create trigger after_insert_order
after insert on orders
for each row
execute procedure insert_trigger1();


--select * from orders;
--delete from customer where customerid =1;
--select * from customer join orders on customer.customerid = orders.order_customerid;
--delete from employee where employeeid = 14;
--select * from customer;
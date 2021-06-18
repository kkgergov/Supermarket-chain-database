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
create or replace function delete_trigger4() returns trigger as $$
begin
	delete from employee
	where employee.employee_storeid = old.storeid;
	
	return old;
end $$ language plpgsql;

drop trigger if exists before_delete_store on store;
create trigger before_delete_store
before delete on store
for each row
execute procedure delete_trigger4();
---------------------------------------------
create or replace function delete_trigger5() returns trigger as $$
declare
	product_cost decimal(15,2);
	product_quantity integer;
	order_id integer;
begin
	select old.quantityordered into product_quantity;
	select old.details_orderid into order_id;
	
	select price into product_cost
	from product
	where product.productid = old.details_productid;
	--RAISE NOTICE '%, %', product_quantity, product_cost;

	update payment
	set amount = amount - (product_quantity*product_cost)
	where payment.paymentid = order_id;
	
	call update_order_status(order_id);
	
	return old;
end $$ language plpgsql;

drop trigger if exists before_delete_orderdetails on orderdetails;
create trigger before_delete_orderdetails
before delete on orderdetails
for each row
execute procedure delete_trigger5();
---------------------------------------------
create or replace function insert_trigger2() returns trigger as $$
declare
	product_cost decimal(15,2);
	product_quantity integer;
	order_id integer;
begin
	select new.quantityordered into product_quantity;
	select new.details_orderid into order_id;
	
	select price into product_cost
	from product
	where product.productid = new.details_productid;
	--RAISE NOTICE '%, %', product_quantity, product_cost;

	update payment
	set amount = amount + product_quantity*product_cost
	where payment.paymentid = order_id;
	
	call update_order_status(order_id);
	
	return new;
end $$ language plpgsql;

drop trigger if exists after_insert_orderDetails on orderdetails;
create trigger after_insert_orderDetails
after insert on orderdetails
for each row
execute procedure insert_trigger2();

--select * from payment where paymentid = 2;
--insert into OrderDetails (details_productid, details_orderid, quantityordered) values (20, 2, 3);
--delete from orderdetails where details_orderid = 2 and details_productid = 20;
--update payment set amount = 0 where paymentid = 2;

--delete from store where storeid = 1;
--select * from orders;
--delete from customer where customerid =1;
--select * from customer join orders on customer.customerid = orders.order_customerid;
--delete from employee where employeeid = 14;
--select * from customer;
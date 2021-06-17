--FUNCTIONS TESTS

-->(1) display number of failed orders of the employee with id 1
/*
select employeeid, customerid, status
from customer left outer join employee ON employee.employeeid = customer.customer_employeeid left outer join orders ON orders.order_customerid = customer.customerid
where employeeid = 1
order by employeeid, customerid;
*/

/*
insert into Customer (customer_employeeid, firstname, middleinitial, lastname, creditlimit, phone, postalcode) values (1, 'Olwen', 'L', 'Lartice', 40.74, '438-828-5608', 1035);
insert into Orders (order_customerid, orderdate, status, misccomments) values (51, '2/13/2021', 'failed', 'ac lobortis vel dapibus at diam nam tristique tortor eu');
insert into Orders (order_customerid, orderdate, status, misccomments) values (51, '2/13/2021', 'failed', 'ac lobortis vel dapibus at diam nam tristique tortor eu');
*/

--select * from num_unsuccessful_orders(1);

--delete from customer where customerid = 51;


-->(2) display if an employee should be fired (if employee has more than one failed orders where the order didnt fail becouse of declined debit card)

--select * from employee where should_be_fired(employeeid);

/*select employeeid, customerid, orderid, status, creditlimit, amount
from customer left outer join employee ON employee.employeeid = customer.customer_employeeid 
			left outer join orders ON orders.order_customerid = customer.customerid left outer join payment ON payment.payment_customerid = customer.customerid
where employeeid = 6
order by employeeid, customerid;*/

--update orders set status = 'completed' where orderid = 43;
--update orders set status = 'failed' where orderid = 43;



--TRIGGERS TESTS

-->(1) deleting row from employee will preserve the hierarchy
/*
with recursive supermarket_hierarchy as(
	select employeeid, firstname, reports_to from employee where employeeid = 2
	union
	select e.employeeid, e.firstname, e.reports_to from employee e
	inner join supermarket_hierarchy s on s.employeeid = e.reports_to
)select * from supermarket_hierarchy order by employeeid;
*/

--delete from employee where employeeid = 5;


-->(2) if we try to insert order with completed or other status but customer's credit card has been declined it gets automatically updated to false
/*
insert into Customer (customer_employeeid, firstname, middleinitial, lastname, creditlimit, phone, postalcode) values (1, 'Olwen', 'L', 'Lartice', 40.74, '438-828-5608', 1035);
insert into Payment (payment_customerid, paymentdate, amount) values (51, '1/9/2021', 638.94);
insert into Orders (order_customerid, orderdate, status, misccomments) values (51, '2/13/2021', 'completed', 'ac lobortis vel dapibus at diam nam tristique tortor eu');
select * from orders where orderid = 51;*/
--delete from customer where customerid = 51;


--STORED PROCEDURES TEST

-->(1) fires the employees that satisfy the should_be_fired(id) condition
--call fire_underperforming();
--select * from employee;



--VIEWS TEST
-->(1) lists clients, their names, date of order and all the products they tried to purchase but the credit card got declined
--select * from invalid_payments;
-->(2) for each store gives the id of the employee who has serviced the most customers
--select * from best_employee;

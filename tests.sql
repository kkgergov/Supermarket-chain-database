--FUNCTIONS TESTS

-->(1) display number of failed orders of the employee with id 1
	--lets check the employee with id 1
	/*
	select employeeid, customerid, orderid, status
	from customer join employee ON employee.employeeid = customer.customer_employeeid join orders ON orders.order_customerid = customer.customerid
	where employeeid = 1
	order by employeeid, customerid;
	*/

	--select * from num_unsuccessful_orders(1);


-->(2) display if an employee should be fired (if employee has more than one failed orders where the order didnt fail becouse of declined debit card)

--select * from employee where should_be_fired(employeeid);

/*select employeeid, customerid, orderid, status, creditlimit, amount
from customer left outer join employee ON employee.employeeid = customer.customer_employeeid 
			left outer join orders ON orders.order_customerid = customer.customerid left outer join payment ON payment.payment_customerid = customer.customerid
where employeeid = 6
order by employeeid, customerid;*/



--TRIGGERS TESTS

-->(1) deleting row from employee will preserve the hierarchy

/*with recursive supermarket_hierarchy as(
	select employeeid, firstname, reports_to from employee where employeeid = 2
	union
	select e.employeeid, e.firstname, e.reports_to from employee e
	inner join supermarket_hierarchy s on s.employeeid = e.reports_to
)select * from supermarket_hierarchy order by employeeid;*/

--delete from employee where employeeid = 5;

-->(2) if we try to insert new orderdetails, the amount that needs to be paid will increase, same with delete

--update payment set amount = 0 where paymentid = 2;
--select * from payment where paymentid = 2;
--insert into OrderDetails (details_productid, details_orderid, quantityordered) values (20, 2, 3);
--delete from orderdetails where details_orderid = 2 and details_productid = 20;



--STORED PROCEDURES TEST, refresh database

-->(1) fires the employee if it satisfies the should_be_fired(emp_id) condition
--select * from employee where should_be_fired(employeeid);
--call fire(2);
--call fire(6);

-->(2) promotes employee (updates the reports_to to correspong to employee higher in the hierarchy)
/*
with recursive supermarket_hierarchy as(
	select employeeid, firstname, reports_to from employee where employeeid = 2
	union
	select e.employeeid, e.firstname, e.reports_to from employee e
	inner join supermarket_hierarchy s on s.employeeid = e.reports_to
)select * from supermarket_hierarchy order by employeeid;
*/
--call promote(2)
--call promote(6)

-->(3) updates order status to failed if the payment ammount exceeds the creditlimit
--select * from orders where orderid = 9;
--insert into OrderDetails (details_productid, details_orderid, quantityordered) values (20, 9, 3000);

--VIEWS TEST, refresh database

-->(1) lists clients, their names, date of order and all the products they tried to purchase but the credit card got declined
--select * from invalid_payments;

-->(2) for each store gives the id of the employee who has serviced the most customers
--select * from best_employee;


drop view if exists invalid_payments;

create view invalid_payments as
select  customer.firstname as customername, orders.orderdate as orderdate, string_agg(productname, ',') as products
from payment inner join customer ON customer.customerid = payment.payment_customerid
	inner join Orders on customer.customerid = orders.order_customerid
	inner join orderdetails ON orderdetails.details_orderid = Orders.orderid
	inner join product ON product.productid = orderdetails.details_productid
where payment.amount > customer.creditlimit 
group by Customer.customerid, Orders.orderid;


drop view if exists best_employee;

create view best_employee as
select storeid, employeeid as best_employee_id, employee.firstname 
from store as S inner join employee ON employee.employee_storeid = S.storeid
	inner join customer ON customer.customer_employeeid = employee.employeeid
where employeeid = (select employeeid
						from employee join customer on customer.customer_employeeid = employee.employeeid
						where employee.employee_storeid = S.storeid
						group by employee.employeeid
						order by count(customer.customerid) desc
						limit 1)
group by S.storeid, employeeid;
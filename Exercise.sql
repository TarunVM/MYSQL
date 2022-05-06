create database Exercise;
 
use Exercise;

select * from bank_inventory_pricing; 

#Q1. Print product, sum of quantity more than 5 sold during all three months.  
Select product,sum(quantity) from bank_inventory_pricing group by product having sum(quantity)> 5;
/* ===================================================================================================== */

#Q2.Print product, quantity and month  for which estimated_sale_price is less than purchase_cost
select product,quantity,month from bank_inventory_pricing where estimated_sale_price < purchase_cost; 
/* ===================================================================================================== */

#Q3. Extarct the 3rd highest value of column Estimated_sale_price from bank_inventory_pricing dataset
select * from 
(select Estimated_sale_price from bank_inventory_pricing order by Estimated_sale_price desc limit 3) as Temp 
order by Estimated_sale_price limit 1;

/* ===================================================================================================== */

#Q4. Count all duplicate values of column Product from table bank_inventory_pricing
Select product, count(product) from bank_inventory_pricing group by product having count(product)>1;
/* ===================================================================================================== */

#Q5. Create a view 'bank_details' for the product 'PayPoints' and Quantity is greater than 2 
create view bank_details
as
select * from bank_inventory_pricing where product='PayPoints' and quantity>2;

select * from bank_details;
/* ===================================================================================================== */

#Q6 Update view bank_details1 and add new record in bank_details1.
-- --example(Producct=PayPoints, Quantity=3, Price=410.67)
create view bank_details1
as
select * from bank_inventory_pricing;
 
insert into bank_details1(Product,quantity,price) values('Paypoints',3,'410.67');
select * from bank_details1;
/* ===================================================================================================== */

#Q7.Real Profit = revenue - cost  Find for which products, branch level real profit is more than the estimated_profit in Bank_branch_PL.
select * from Bank_branch_PL ;

SELECT Product, Branch, revenue-Cost AS RealProfit, estimated_profit
FROM bank_branch_pl
WHERE revenue-Cost > Estimated_profit;

/* ===================================================================================================== */

#Q8.Find the least calculated profit earned during all 3 periods

SELECT min(revenue-Cost) AS Profit, month
FROM bank_branch_pl
GROUP BY month
ORDER BY Profit;

/* ===================================================================================================== */

#Q9. In Bank_Inventory_pricing, 
-- a) convert Quantity data type from numeric to character 
select cast(quantity as char(20)) as quantity from Bank_Inventory_pricing;

-- b) Add then, add zeros before the Quantity field.  
select concat('00',cast(quantity as char(20))) as Quantity from Bank_Inventory_pricing;

select * from Bank_Inventory_pricing;
/* ===================================================================================================== */

#Q10. Write a MySQL Query to print first_name , last_name of the employee_details whose first_name Contains ‘U’
select first_name , last_name from employee_details where first_name like '%U%';
/* ===================================================================================================== */

#Q11.Reduce 30% of the cost for all the products and print the products whose  calculated profit at branch is exceeding estimated_profit .
Select product, Real_Profit, estimated_profit  
from (Select product,branch,estimated_profit, revenue - cost as Real_Profit 
from(select product,branch,sum(cost*0.7) as cost, sum(revenue) as revenue, sum(estimated_profit) as estimated_profit from Bank_branch_PL group by branch)
as profit) as prof where Real_Profit > estimated_profit;

Select product,branch,revenue,cost,cost*0.7 as Red_cost, revenue - (cost*0.7) as Real_Profit ,estimated_profit
from Bank_branch_PL  where revenue - (cost*0.7) > estimated_profit;

select * from Bank_branch_PL;

/* ===================================================================================================== */

#Q12.Write a MySQL query to print the observations from the Bank_Inventory_pricing table excluding the values “BusiCard” And “SuperSave” from the column Product
select * from Bank_Inventory_pricing where product Not in ('BusiCard','SuperSave');
/* ===================================================================================================== */

#Q13. Extract all the columns from Bank_Inventory_pricing where price between 220 and 300
select * from Bank_Inventory_pricing where price between 220 and 300;

/* ===================================================================================================== */

#Q14. Display all the non duplicate fields in the Product form Bank_Inventory_pricing table and display first 5 records.
select * from Bank_Inventory_pricing;
select distinct product from Bank_Inventory_pricing limit 5;


/* ===================================================================================================== */

#Q15.Update price column of Bank_Inventory_pricing with an increase of 15%  when the quantity is more than 3.
select * from Bank_Inventory_pricing;

update Bank_Inventory_pricing set price=price*1.15 where quantity>3;
/* ===================================================================================================== */

#Q16. Show Round off values of the price without displaying decimal scale from Bank_Inventory_pricing
select price,ROUND(price) from Bank_Inventory_pricing;

/* ===================================================================================================== */

#Q17.Increase the length of Product size by 30 characters from Bank_Inventory_pricing.
describe Bank_Inventory_pricing;

alter table Bank_Inventory_pricing modify product char(50);

/* ===================================================================================================== */

#Q18. Add '100' in column price where quantity is greater than 3 and dsiplay that column as 'new_price' 

select product,price,price + 100 as new_price ,quantity from Bank_Inventory_pricing where quantity>3;

/* ===================================================================================================== */

#Q19. Display all saving account holders have “Add-on Credit Cards" and “Credit cards" 

select * from bank_account_details;
Select /* account_number,customer_id,*/customer_name,account_type from (
select bank_account_details.account_number, bank_account_details.customer_id, bank_customer.customer_name , bank_account_details.account_type 
from bank_account_details left join bank_customer on
bank_account_details.customer_id = bank_customer.customer_id) as Cust_Name
where account_type = 'Add-on Credit Card' or account_type = 'Credit Card';

/*=====================================================================================================*/

#Q20.
# a) Display records of All Accounts , their Account_types, the transaction amount.
Select bank_account_details.account_number,bank_account_details.account_type,bank_account_transaction.Transaction_amount 
from bank_account_details inner join bank_account_transaction 
where bank_account_details.account_number=bank_account_transaction.account_number;

# b) Along with first step, Display other columns with corresponding linking account number, account types 
select * from bank_account_relationship_details;

/* Adding to first step */
create table  acc_type_trans 
as 
Select bank_account_details.account_number,bank_account_details.account_type,bank_account_transaction.Transaction_amount 
from bank_account_details inner join bank_account_transaction 
where bank_account_details.account_number=bank_account_transaction.account_number;

select * from acc_type_trans;

select * from bank_account_relationship_details as BAR inner join acc_type_trans as ATT on ATT.Account_Number = BAR.Account_Number;

# c) After retrieving all records of accounts and their linked accounts, display the transaction amount of accounts appeared  in another column.


select ATT.Account_Number,Linking_Account_Number, Transaction_amount from bank_account_relationship_details as BAR inner join acc_type_trans as ATT on ATT.Account_Number = BAR.Account_Number;


/* ===================================================================================================== */

#Q21.Display all type of “Credit cards”  accounts including linked “Add-on Credit Cards" 
# type accounts with their respective aggregate sum of transaction amount.
select account_number,account_type from bank_account_details where account_type IN('credit card','Add-on Credit Card');
# Ref: Check linking relationship in bank_transaction_relationship_details.
# Check transaction_amount in bank_account_transaction. 
select account_number, SUM(Transaction_amount) from bank_account_transaction group by account_number;

select Customer_id, account_number, account_type, Linking_Account_Number
from bank_account_relationship_details;
/* ===================================================================================================== */

#Q22. Compare the aggregate transaction amount of current month versus aggregate transaction with previous months.
# Display account_number, transaction_amount , 
select account_number,transaction_amount from bank_account_transaction;

-- sum of current month transaction amount ,
select * from bank_account_transaction;

select sum(transaction_amount) 
from(select account_number,transaction_amount,transaction_Date 
from bank_account_transaction where transaction_Date like '_____04%') as sum order by Transaction_amount;

-- current month transaction date , 
select account_number, Transaction_Date
from(select account_number,transaction_amount,transaction_Date 
from bank_account_transaction where transaction_Date like '_____04%') as sum order by Transaction_Date;

-- sum of previous month transaction amount ,
select sum(transaction_amount) 
from(select account_number,transaction_amount,transaction_Date 
from bank_account_transaction where transaction_Date like '_____03%') as sum order by Transaction_amount;
 
-- previous month transaction date.
select account_number, Transaction_Date
from(select account_number,transaction_amount,transaction_Date 
from bank_account_transaction where transaction_Date like '_____03%') as sum order by Transaction_Date;



Select avg(Transaction_amount), sum(Transaction_amount), month(Transaction_date) as Transaction_month from bank_account_transaction
group by month(Transaction_date)
order by Transaction_date desc;


/* ===================================================================================================== */

#Q23.Display individual accounts absolute transaction of every next  month is greater than the previous months .
Select BAT.Account_Number, abs(BAT.Transaction_amount) as Abs_Transaction_amount, BAT.Transaction_date from bank_account_transaction BAT
where BAT.Account_Number IN (
	Select BAT2.Account_Number from bank_account_transaction BAT2
    where month(BAT.Transaction_date) < month(BAT2.Transaction_date) and abs(BAT.Transaction_amount) > abs(BAT2.Transaction_amount)
)
order by BAT.Transaction_date desc;
/* ===================================================================================================== */

#Q24. Find the no. of transactions of credit cards including add-on Credit Cards
Select count(account_type) as No_of_transactions_CC_AOCC from (select * from (select bank_account_details.account_number, bank_account_details.account_type, bank_account_transaction.transaction_amount 
from bank_account_details left join bank_account_transaction on bank_account_details.account_number = bank_account_transaction.account_number) as Temp 
where account_type in ('credit card','add-on Credit Card')) as count1;

/* ===================================================================================================== */

#Q25.From employee_details retrieve only employee_id , first_name ,last_name phone_number ,salary, job_id where department_name is Contracting (Note
#Department_id of employee_details table must be other than the list within IN operator.
select * from employee_details;
select * from department_details;

select employee_id , first_name ,last_name, phone_number ,salary, job_id ,department_id from(
select employee_details.employee_id , first_name ,last_name, phone_number ,salary, job_id,employee_details.department_id,department_details.department_name 
from employee_details inner join department_details 
where employee_details.department_id=department_details.department_id) as Temp_Dept_Name
where department_name='Contracting';

/* ===================================================================================================== */

#Q26. Display savings accounts and its corresponding Recurring deposits transactions are more than 4 times.

select * from bank_account_details;

	select * from bank_account_transaction;
	select Account_number, count(Account_number) as No_of_Transactions from bank_account_transaction group by Account_number having count(Account_number)>4;


/* ===================================================================================================== */

#Q27. From employee_details fetch only employee_id, ,first_name, last_name , phone_number ,email, job_id where job_id should not be IT_PROG.
select employee_id,first_name, last_name , phone_number ,email, job_id from employee_details where job_id Not IN('IT_PROG');

/* ===================================================================================================== */

#Q29.From employee_details retrieve only employee_id , first_name ,last_name phone_number ,salary, job_id where manager_id is '60' (Note
#Department_id of employee_details table must be other than the list within IN operator.
select * from employee_details;
select employee_id,first_name, last_name , phone_number ,email, job_id from employee_details where manager_id = 60;

/* ===================================================================================================== */

#Q30.Create a new table as emp_dept and insert the result obtained after performing inner join on the two tables employee_details and department_details.

create table emp_dept as
select employee_details.EMPLOYEE_ID, FIRST_NAME, LAST_NAME, Email, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, employee_details.MANAGER_ID, department_details.DEPARTMENT_ID, DEPARTMENT_NAME, LOCATION_ID 
from employee_details inner join department_details on employee_details.EMPLOYEE_ID = department_details.EMPLOYEE_ID ;

select * from emp_dept;
/* ===================================================================================================== */

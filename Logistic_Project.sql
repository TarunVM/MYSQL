create database Logistics;

use Logistics;

create table Employee_Details(Emp_ID int(5) primary key,Emp_name varchar(30),
Emp_Branch varchar(15),Emp_Designation varchar(40),Emp_Addr varchar(100),
Emp_Cont_No varchar(10));

describe Employee_Details;

select * from Employee_Details;

/*=========================================================*/

create table Membership(M_ID int primary key, START_DATE Text, END_DATE Text);

describe Membership;

select * from Membership;

/*=========================================================*/


create table Customer(Cust_ID int(4) primary key, Cust_Name varchar(30), 
Cust_Email_ID varchar(50) , Cust_Cont_No varchar(10), Cust_Addr varchar(100),
Cust_Type varchar(30), Membership_M_ID int ,foreign key (Membership_M_ID) references Membership(M_ID));

describe Customer;

select * from Customer;
/*=========================================================*/


create table Payment_Details(Payment_ID varchar(40) primary key, Amount int, 
Payment_Status varchar(10), Payment_Date text, Payment_Mode varchar(25), 
Shipment_sh_ID varchar(6), foreign key(Shipment_sh_ID) references Shipment_Details(SD_ID),
Shipment_Client_C_ID int(4), foreign key(Shipment_Client_C_ID) references Customer(Cust_ID));

describe Payment_Details;

select * from Payment_Details;

/*=========================================================*/


create table Shipment_Details(SD_ID varchar(6) primary key, SD_Content varchar(40), 
SD_Domain varchar(15), SD_Type varchar(15), SD_Weight varchar(10), SD_Charges int(10),
SD_Addr varchar(100), DS_Addr varchar(100), Customer_Cust_ID int(4), 
foreign key(Customer_Cust_ID) references Customer(Cust_ID));

describe Shipment_Details;

select * from Shipment_Details;


/*=========================================================*/


create table Status1(Current_ST varchar(15), Sent_Date text, 
Delivery_Date text, SH_ID varchar(6) primary key);

describe status1;

select * from status1;


/*=========================================================*/

create table Employee_Manages_Shipment(
Employee_E_ID int(5), foreign key(Employee_E_ID) references Employee_Details(Emp_ID),
Shipment_SH_ID varchar(6), foreign key(Shipment_SH_ID) references Shipment_Details(SD_ID),
Status_SH_ID varchar(6), foreign key(Status_SH_ID) references status1(SH_ID));

describe Employee_Manages_Shipment;

select * from Employee_Manages_Shipment;


/*=========================================================*/


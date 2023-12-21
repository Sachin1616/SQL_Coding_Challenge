create database Car_Rental_System;
use Car_Rental_System;

CREATE TABLE vehicle (
    vehicleid INT PRIMARY KEY,
    make VARCHAR(15),
    model VARCHAR(15),
    year INT,
    dailyrate DECIMAL(10, 2),
    available INT CHECK(available IN(0,1)),
    passengercapacity INT,
    enginecapacity INT
);

CREATE TABLE customer (
    customerid INT PRIMARY KEY,
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    phonenumber VARCHAR(15) UNIQUE
);

CREATE TABLE lease (
    leaseid INT PRIMARY KEY,
    vehicleid INT,
    customerid INT,
    startdate DATE,
    enddate DATE,
    leasetype VARCHAR(10) CHECK(leasetype IN('Daily','Monthly')),
    FOREIGN KEY (vehicleid) REFERENCES Vehicle(vehicleid) ON DELETE CASCADE,
    FOREIGN KEY (customerid) REFERENCES Customer(customerid) ON DELETE CASCADE
);

CREATE TABLE payment (
    paymentid INT PRIMARY KEY,
    leaseid INT,
    paymentdate DATE,
    amount DECIMAL(10, 2),
    FOREIGN KEY (leaseid) REFERENCES Lease(leaseid) on delete cascade
);


INSERT INTO Vehicle 
VALUES
    (1, 'Toyota', 'Camry', 2022, 50.00, 1, 4, 1450),
    (2, 'Honda', 'Civic', 2023, 45.00, 1, 7, 1500),
    (3, 'Ford', 'Focus', 2022, 48.00, 0,4, 1400),
    (4, 'Nissan', 'Altima', 2023, 52.00, 1, 7, 1200),
    (5, 'Chevrolet', 'Malibu', 2022, 47.00, 1, 4, 1800),
    (6, 'Hyundai', 'Sonata', 2023, 49.00, 0, 7, 1400),
    (7, 'BMW', '3 Series', 2023, 60.00, 1, 7, 2499), 
    (8, 'Mercedes', 'C-Class', 2022, 58.00, 1, 8, 2499),
    (9, 'Audi', 'A4', 2022, 55.00, 0, 4, 2599),
    (10, 'Lexus', 'ES', 2023, 54.00, 1, 4, 2500);

SELECT * FROM [dbo].[vehicle];


INSERT INTO Customer 
VALUES
    (1, 'John', 'Doe', 'johndoe@example.com', '555-555-5555'),
    (2, 'Jane', 'Smith', 'janesmith@example.com', '555-123-4567'),
    (3, 'Robert', 'Johnson', 'robert@example.com', '555-789-1234'),
    (4, 'Sarah', 'Brown', 'sarah@example.com', '555-456-7890'),
    (5, 'David', 'Lee', 'david@example.com', '555-987-6543'),
    (6, 'Laura', 'Hall', 'laura@example.com', '555-234-5678'),
    (7, 'Michael', 'Davis', 'michael@example.com', '555-876-5432'),
    (8, 'Emma', 'Wilson', 'emma@example.com', '555-432-1098'),
    (9, 'William', 'Taylor', 'william@example.com', '555-321-6547'),
    (10, 'Olivia', 'Adams', 'olivia@example.com', '555-765-4321');

SELECT * FROM [dbo].[customer];

INSERT INTO lease 
VALUES
    (1, 1, 1, '2023-01-01', '2023-01-05', 'Daily'),
    (2, 2, 2, '2023-02-15', '2023-02-28', 'Monthly'),
    (3, 3, 3, '2023-03-10', '2023-03-15', 'Daily'),
    (4, 4, 4, '2023-04-20', '2023-04-30', 'Monthly'),
    (5, 5, 5, '2023-05-05', '2023-05-10', 'Daily'),
    (6, 4, 3, '2023-06-15', '2023-06-30', 'Monthly'),
    (7, 7, 7, '2023-07-01', '2023-07-10', 'Daily'),
    (8, 8, 8, '2023-08-12', '2023-08-15', 'Monthly'),
    (9, 3, 3, '2023-09-07', '2023-09-10', 'Daily'),
    (10, 10, 10, '2023-10-10', '2023-10-31', 'Monthly');

SELECT * FROM [dbo].[lease];



INSERT INTO payment 
VALUES
    (1, 1, '2023-01-03', 200.00),
    (2, 2, '2023-02-20', 1000.00),
    (3, 3, '2023-03-12', 75.00),
    (4, 4, '2023-04-25', 900.00),
    (5, 5, '2023-05-07', 60.00),
    (6, 6, '2023-06-18', 1200.00),
    (7, 7, '2023-07-03', 40.00),
    (8, 8, '2023-08-14', 1100.00),
    (9, 9, '2023-09-09', 80.00),
    (10, 10, '2023-10-25', 1500.00);


--Q1
update vehicle set dailyrate=68 where make='Mercedes';

--Q2
delete from customer where customerid=1;

--Q3
exec sp_rename 'payment.paymentdate', 'transactiondate';

--Q4
select * from customer 
where email='michael@example.com';

--Q5
select * from lease 
where getdate() between startdate and enddate;

--Q6
select p.paymentid,p.leaseid,p.amount from payment p 
left join lease l on p.leaseid =l.leaseid inner join customer c on l.customerid=c.customerid where c.phonenumber='555-321-6547';

--Q7
select avg(dailyrate) as average_daily_rate from vehicle where available=1;

--Q8
select dailyrate as highest_daily_rate from vehicle 
order by(dailyrate) desc offset 0 rows fetch next 1 rows only;

--Q9
select vehicle.vehicleid, vehicle.make ,vehicle.model from vehicle  
left join lease on vehicle.vehicleid=lease.vehicleid left join customer on customer.customerid=lease.customerid where customer.customerid=1;

--Q10
select * from lease 
order by(startdate) desc
offset 0 rows fetch next 1 rows only;


--Q11
select * from payment where year(transactiondate)='2023';


--Q12
select customerid,firstname from customer 
where customerid not in(select lease.customerid from lease  left join payment on lease.leaseid=payment.leaseid where payment.leaseid is null) 


--Q13
SELECT v.vehicleid, v.make, v.model, ISNULL(SUM(payment.amount), 0) AS TotalPayments
FROM vehicle v LEFT JOIN lease 
ON v.vehicleid = lease.vehicleid
LEFT JOIN payment ON lease.leaseid = payment.leaseid
GROUP BY v.vehicleid, v.make, v.model;


--Q14
SELECT customer.*, ISNULL(SUM(p.amount), 0) AS TotalPayments FROM customer  
LEFT JOIN lease ON customer.customerid = lease.customerid LEFT JOIN payment p ON lease.leaseid = p.leaseid 
GROUP BY customer.customerid, customer.firstname, customer.lastname, customer.email, customer.phonenumber;


--Q15
Select lease.*, vehicle.make, vehicle.model FROM lease, vehicle 
WHERE lease.vehicleid = vehicle.vehicleid;

--Q16
DECLARE @today DATE = '2023-05-05' 
SELECT lease.*, customer.firstname, customer.lastname, vehicle.make, vehicle.model FROM lease, customer, vehicle 
WHERE lease.customerid = customer.customerid AND lease.vehicleid = vehicle.vehicleid AND lease.enddate >= @today;

SELECT *from payment;

--Q17
SELECT TOP 1 customer.customerid, customer.firstname, customer.lastname FROM customer, lease , payment
WHERE customer.customerid = lease.customerid AND lease.leaseid = payment.leaseid 
GROUP BY customer.customerid, customer.firstname, customer.lastname ORDER BY SUM(payment.amount) DESC;

--Q18
SELECT vehicle.vehicleid, vehicle.make, vehicle.model, lease.startdate, lease.enddate, lease.leasetype FROM vehicle, lease
WHERE vehicle.vehicleid = lease.vehicleid;
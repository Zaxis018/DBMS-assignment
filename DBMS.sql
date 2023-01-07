CREATE database Employee_DB1;
use Employee_DB1;

create table Tbl_employee(
employee_name varchar(255) primary key,
street VARCHAR(255),
city VARCHAR(255)
);

create table Tbl_works(
	employee_name varchar(255) primary key, 
    company_name varchar(255),
    salary INT
);

 create table Tbl_company(
  company_name varchar(255) primary key, 
	city varchar(255)
 );
 

create table Tbl_manages(
	employee_name varchar(255) primary key, 
    manager_name varchar(255)
);

#assigning foreign key

 ALTER table Tbl_works
 add foreign key (employee_name) references Tbl_employee(employee_name),
 add foreign key(company_name) references Tbl_company(company_name);

 ALTER table Tbl_manages
 add FOREIGN KEY(employee_name) references tbl_employee(employee_name);
 
  #Adding Data
INSERT INTO Tbl_employee (employee_name, street, city)
VALUES ('John Smith', '123 Main St', 'New York'),
       ('Jane Doe', '456 Maple Ave', 'Chicago'),
       ('Bob Johnson', '789 Pine St', 'Los Angeles'),
       ('Samantha Williams', '321 Park Ave', 'New York'),
       ('Michael Brown', '654 Oak St', 'Chicago'),
       ('Emily Davis', '912 Birch St', 'Los Angeles'),
        ('Tim Smith', '123 Main St', 'New York'),
       ('Julie Johnson', '456 Maple Ave', 'Chicago'),
       ('Mike Brown', '789 Pine St', 'Los Angeles'),
       ('Jessica Williams', '321 Park Ave', 'New York'),
       ('David Davis', '654 Oak St', 'Chicago'),
       ('Sarah Jackson', '912 Birch St', 'Los Angeles'),
       ('Jones' ,'192 brst', 'old town');
       
select * from Tbl_employee

INSERT INTO Tbl_works (employee_name, company_name, salary) VALUES 
('John Smith', 'First Bank Corporation', 75000),        
('Jane Doe', 'First Bank Corporation', 80000),        
('Bob Johnson', 'First Bank Corporation', 90000),        
('Samantha Williams', 'TechCorp', 95000),        
('Michael Brown', 'TechCorp', 100000),        
('Emily Davis', 'TechCorp', 110000),         
('Tim Smith', 'Small Bank Corporation', 75000),        
('Julie Johnson', 'Small Bank Corporation', 80000),        
('Mike Brown', 'Small Bank Corporation', 90000),        
('Jessica Williams', 'Small Bank Corporation', 95000),        
('David Davis', 'Small Bank Corporation', 100000),        
('Sarah Jackson', 'Small Bank Corporation', 110000),
('Jones' , 'Techcorp', 100000);

       
select * from Tbl_works
 
 INSERT INTO Tbl_company (company_name, city)
 VALUES ('Small Bank Corporation', 'New York'),
		('Big Corporation', 'New York'),
		('Mid-Size Company', 'Chicago'),
		('Small Business', 'Los Angeles'),
		('Startup Inc.', 'San Francisco'),
		('Global Enterprises', 'New York'),
        ('Regional Firm', 'Chicago'),
		('First Bank Corporation', 'New York'),
		('TechCorp', 'old town');
        
select * from Tbl_company

INSERT INTO Tbl_manages(employee_name, manager_name)
VALUES ('Julie Johnson', 'Tim Smith'),
       ('Mike Brown', 'Julie Johnson'),
       ('Sarah Jackson', 'Jessica Williams'),
       ('Jane Doe', 'John Smith'),
       ('Bob Johnson', 'Jane Doe'),
       ('Michael Brown', 'Samantha Williams'),
       ('Emily Davis', 'Michael Brown'),
       ('Jessica Williams', 'John Smith');

select * from Tbl_manages

#***********************************************************Q2a*******************************************************
-- method1
select employee_name from Tbl_works where company_name='First Bank Corporation';

-- method2
select employee_name from tbl_employee natural join tbl_works where company_name = 'First Bank Corporation';

#************************************************************2b***********************************************************
-- method 1
select employee_name,city from Tbl_Employee where employee_name in
(select employee_name from Tbl_works where company_name='First Bank Corporation');

-- method 2
select employee_name,city from Tbl_Employee natural join Tbl_works where company_name = 'First Bank Corporation';

#*************************************************************2c***********************************************************
-- method 1
select employee_name,street,city from Tbl_Employee where employee_name in
(select employee_name from Tbl_works where company_name='First Bank Corporation' and salary > 10000);

-- method2
select employee_name,street,city from Tbl_Employee natural join Tbl_works where company_name='First Bank Corporation' and salary > 10000;

#***************************************************************2d********************************************************

-- method 1
select * from Tbl_employee 
where Tbl_employee.city in
(select city from Tbl_company where Tbl_company.company_name in
(select company_name from Tbl_works where Tbl_works.employee_name= Tbl_employee.employee_name));
-- ------------------------------------------------------------- OR--------------------------------------------------
SELECT E.employee_name FROM Tbl_employee E, Tbl_company C, Tbl_works W
WHERE
    E.employee_name = W.employee_name
    AND W.company_name = C.company_name
    AND E.city = C.city;

-- method 2 
select * from tbl_works natural join tbl_company natural join tbl_employee where tbl_employee.city= tbl_company.city;

CREATE TABLE Tbl_managers (
  manager_name VARCHAR(255),
  city VARCHAR(255),
  street VARCHAR(255)
);
INSERT INTO Tbl_managers (manager_name, city, street)
VALUES ('Tim Smith', 'Chicago', '456 Maple Ave'),
       ('Jane Doe', 'San Francisco', '456 Market St'),
       ('Bob Johnson', 'Chicago', '789 Lake Shore Dr'),
       ('Samantha Williams', 'Seattle', '321 Pike Pl'),
       ('Michael Brown', 'Los Angeles', '654 Sunset Blvd'),
       ('Emily Davis', 'Houston', '246 Texas St'),
       ('William Thompson', 'Miami', '159 South Beach'),
       ('Ashley Johnson', 'Philadelphia', '753 Market St');
    

#**************************************************************2e****************************************************************
 -- method 1
SELECT *
FROM Tbl_employee e
WHERE e.city = (SELECT city FROM Tbl_managers Where Tbl_managers.manager_name = 
(SELECT manager_name FROM Tbl_manages  WHERE Tbl_manages.employee_name = e.employee_name))
and  e.street = (SELECT street FROM Tbl_managers Where Tbl_managers.manager_name = 
(SELECT manager_name FROM Tbl_manages  WHERE Tbl_manages.employee_name = e.employee_name));
-- -------------------------------------------------OR-------------------------------------------------------

SELECT E.employee_name FROM Tbl_employee E,Tbl_company C,Tbl_works W
WHERE
    E.employee_name = W.employee_name
    AND W.company_name = C.company_name
    AND E.city = C.city;


-- method 2

select * from tbl_employee natural join tbl_manages natural join tbl_managers where tbl_employee.city= tbl_managers.city and
 tbl_employee.street= tbl_managers.street ;

#******************************************************************2f*********************************************************
SELECT employee_name from Tbl_works WHERE company_name != 'First Bank Corporation';

#****************************************************************2g************************************************************
-- method 1
SELECT @maxsal := Max(salary) 
FROM Tbl_works Where company_name = 'Small Bank Corporation';
SELECT employee_name from Tbl_works where salary > @maxsal;
-- method 2
select employee_name from tbl_works where salary >
(select max(salary) from tbl_works natural join tbl_company  Where company_name = 'Small Bank Corporation');

#******************************************************************2h*********************************************************
-- method 1 
Select company_name from Tbl_company WHERE city IN(SELECT city from Tbl_company where company_name = 'Small Bank Corporation');

-- method 2
 
 #*****************************************************************2i************************************************************
 
SELECT employee_name from tbl_works 
where salary > (select avg(salary) from tbl_works where company_name = tbl_works.company_name);

#*******************************************************************2j********************************************************
SELECT company_name, COUNT(*) as a
FROM tbl_works
GROUP BY company_name
ORDER BY a DESC
LIMIT 1;

#********************************************************************2k*********************************************************
SELECT company_name, SUM(salary) as payroll
FROM Tbl_works
GROUP BY company_name
ORDER BY payroll ASC
LIMIT 1;

#********************************************************************2l*********************************************************
        
SELECT company_name
FROM Tbl_works
GROUP BY company_name
having avg(salary) > (SELECT AVG(salary)
                FROM Tbl_works
                WHERE company_name = 'First Bank Corporation')
                
#######################################################################Q3a###########################################################
 
update Tbl_employee 
SET city = 'Newtown' where employee_name = 'Jones';
select employee_name, city from Tbl_employee; 

#********************************************************************3b***********************************************************

update Tbl_works
SET salary=1.1*salary
where company_name='First Bank Corporation';

#********************************************************************3c**********************************************************
SELECT W.employee_name,W.salary FROM Tbl_works W, Tbl_manages M WHERE
    W.employee_name = M.manager_name
    AND W.company_name = 'First Bank Corporation';

UPDATE Tbl_works W, Tbl_manages M
SET W.salary = 1.1 * W.salary
WHERE
    W.company_name = 'First Bank Corporation'
    AND W.employee_name = M.manager_name;

#*******************************************************************3d***********************************************************
SELECT W.employee_name,W.salary FROM Tbl_works W, Tbl_manages M WHERE
    W.employee_name = M.manager_name
    AND W.company_name = 'First Bank Corporation';
    
    
UPDATE Tbl_works W, Tbl_manages M
SET
    W.salary = (
        CASE
            WHEN (W.salary + salary * 0.1) < 100000 THEN W.salary * 1.1
            ELSE W.salary * 1.03
        END
    )                
WHERE
    W.employee_name = M.manager_name
    AND W.company_name = 'First Bank Corporation';
    
#*******************************************************************3e*****************************************************************
SELECT * FROM Tbl_works;
DELETE FROM Tbl_works WHERE company_name = 'Small Bank Corporation';

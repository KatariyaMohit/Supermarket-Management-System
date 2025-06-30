create database supermarket_db;
use supermarket_db;
CREATE TABLE Employee(
employee_id varchar (20)  NOT NULL,
employee_name varchar (20) NOT NULL,
employee_contact bigint   NOT NULL,         
employee_dob  date  NOT NULL,
employee_email varchar(50)  NOT NULL,
employee_address varchar(50)  NOT NULL,
gender  VARCHAR(10) NOT NULL  check (gender = 'female' or gender='male'),
password varchar(225),
role varchar(255),
PRIMARY KEY (employee_id)
);

select * from Employee;
CREATE TABLE OfferDetails(
offers_id varchar(50)  NOT NULL,
offers_type varchar(50)  NOT NULL,
offers_details varchar(500)  NOT NULL,
offers_start_date date  NOT NULL,
offers_end_date date  NOT NULL,
PRIMARY KEY (offers_id)
    );
CREATE TABLE CustomerType(
type_id varchar(6)  NOT NULL,
type_name varchar(20)  NOT NULL,
PRIMARY KEY (type_id)    
 ) ;
 
CREATE TABLE Customer(
customer_id bigint auto_increment,
customer_name varchar(50)  NOT NULL,
customer_contact int   NOT NULL,
date_of_birth  date  NOT NULL,            
email varchar(50)    NOT NULL,
address varchar(50)  NOT NULL,
gender VARCHAR(20)   NOT NULL check (gender = 'female' or gender='male'),
customer_type_id varchar(6) ,
membership_to date  NOT NULL,
membership_to_from  date  NOT NULL,    
PRIMARY KEY (customer_id),
FOREIGN KEY (customer_type_id) REFERENCES CustomerType(type_id) ON DELETE SET NULL ON UPDATE CASCADE
);
DROP TABLE Customer;


CREATE TABLE Warehouse(
warehouse_no varchar(20),
warehouse_name varchar(50),
PRIMARY KEY (warehouse_no)
); 
    
  
CREATE TABLE Block(
block_id VARCHAR(2)  NOT NULL,
block_name varchar(50)  NOT NULL,
block_incharge_id  varchar(50) ,
PRIMARY KEY (block_id),
FOREIGN KEY (block_incharge_id) REFERENCES Employee(employee_id)  ON DELETE SET NULL ON UPDATE CASCADE
    );  
  
CREATE TABLE Category(
category_id varchar(6)  NOT NULL,
category_name varchar(50)  NOT NULL,
store_id varchar(2)  NOT NULL,
warehouse_no varchar(20),
PRIMARY KEY (category_id),
FOREIGN KEY (store_id) REFERENCES Block(block_id),
FOREIGN KEY (warehouse_no) REFERENCES Warehouse(warehouse_no)
);

CREATE TABLE  PaymentMode(
payment_mode_id varchar(6)  NOT NULL,
mode_of_payment varchar(20)  NOT NULL,
offer_id varchar(50) ,
PRIMARY KEY (payment_mode_id),
FOREIGN KEY (offer_id) REFERENCES OfferDetails(offers_id) ON DELETE SET NULL ON UPDATE CASCADE
);    

CREATE TABLE  InvoiceDetails(
inv_id bigint auto_increment,
cust_id bigint,
amount float  NOT NULL,
inv_date  date   NOT NULL,
cashier_id varchar(10) ,
PRIMARY KEY (inv_id),
FOREIGN KEY (cashier_id) REFERENCES Employee(employee_id) ON DELETE SET NULL ON UPDATE CASCADE,
FOREIGN KEY (cust_id) REFERENCES Customer (customer_id) ON DELETE SET NULL ON UPDATE CASCADE
);
drop table InvoiceDetails;

CREATE TABLE  Product(
product_id varchar(20)  NOT NULL,
product_type varchar(50)  NOT NULL,
brand varchar(20)  NOT NULL,
cost_price float  NOT NULL,
weight varchar(20)  NOT NULL,
selling_price float  NOT NULL,
category_id varchar(600) ,
offer_id  varchar(50) ,
block_count int NOT NULL,
warehouse_count int NOT NULL,
 PRIMARY KEY (product_id),   
FOREIGN KEY (offer_id) REFERENCES OfferDetails(offers_id) ON DELETE SET NULL ON UPDATE CASCADE,
FOREIGN KEY (category_id) REFERENCES Category(category_id) ON DELETE SET NULL ON UPDATE CASCADE
);          

CREATE TABLE Buys(
    product_name varchar(20),
    invoice_id bigint,
    quantity int  ,
    cost float ,
    PRIMARY KEY (product_name,invoice_id),                 
    FOREIGN KEY (invoice_id) REFERENCES InvoiceDetails(inv_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
drop table Buys;
SELECT * FROM Buys;
drop table ReturnSlip;
CREATE TABLE Feedback(
review_id INT AUTO_INCREMENT,
review_text VARCHAR(50)  NOT NULL,
rating int  NOT NULL,
review_date date  NOT NULL,
cust_id bigint ,
invoice_id bigint,
PRIMARY KEY (review_id),   
FOREIGN KEY (cust_id) REFERENCES Customer(customer_id) ON DELETE SET NULL ON UPDATE CASCADE,
FOREIGN KEY (invoice_id) REFERENCES InvoiceDetails(inv_id) ON DELETE SET NULL ON UPDATE CASCADE   
);
drop table Feedback;
CREATE TABLE ReturnSlip(
    slip_no varchar(20)  NOT NULL, 
    inv_id bigint auto_increment,
    product_id varchar(20)  NOT NULL,
    quantity  int  NOT NULL check (quantity > 0),
    return_date date NOT NULL,
    PRIMARY KEY (slip_no, product_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (inv_id) REFERENCES InvoiceDetails(inv_id) ON DELETE CASCADE ON UPDATE CASCADE
);
drop table returnslip;
CREATE TABLE ProductTransferHistory (
    transfer_id INT AUTO_INCREMENT PRIMARY KEY,
    block_name VARCHAR(100) NOT NULL,
    product_id varchar(300) NOT NULL,
    transfer_date DATE NOT NULL,
    transfer_time TIME NOT NULL,
    quantity INT NOT NULL,
    transfer_status VARCHAR(50) DEFAULT 'Completed',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);


CREATE TABLE Complaints (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    supplier VARCHAR(255) NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    issue VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    priority ENUM('low', 'medium', 'high') NOT NULL,
    attachment_path VARCHAR(255),
    status VARCHAR(50) DEFAULT 'Pending'
);

INSERT INTO Employee (employee_id, employee_name, employee_contact, employee_dob, employee_email, employee_address, gender, password, role) VALUES
('0001','Rajavardhan',9392425845,'2005-12-01','marupakarajavardhan339@gmail.com','armoor,Nizamabad','male','Raja@225','Admin'),
('E001', 'Rahul Sharma', 9876543210, '1990-05-14', 'rahul.sharma@example.com', '1234, MG Road, Mumbai', 'male', 'cashier@E001', 'Cashier'),
('E002', 'Pooja Gupta', 8765432109, '1992-11-25', 'pooja.gupta@example.com', '5678, MG Road, Pune', 'female', 'securePassword456!', 'Warehouse Manager'),
('E003', 'Vikram Reddy', 9871234567, '1985-03-19', 'vikram.reddy@example.com', '91011, Brigade Rd, Bangalore', 'male', 'myPass789#', 'Block Incharge'),
('E004', 'Anjali Mehta', 8763213456, '1988-07-30', 'anjali.mehta@example.com', '1213, Connaught Place, Delhi', 'female', 'cashier@E004', 'Cashier'),
('E005', 'Arjun Singh', 9898765432, '1993-01-01', 'arjun.singh@example.com', '1415, Banjara Hills, Hyderabad', 'male', 'ArjunSingh123!', 'Warehouse Manager'),
('E006', 'Sneha Desai', 9876543212, '1995-04-22', 'sneha.desai@example.com', '1617, Salt Lake, Kolkata', 'female', 'Sneha@456', 'Block Incharge'),
('E007', 'Rohit Verma', 9123456789, '1989-09-16', 'rohit.verma@example.com', '1819, Bandra, Mumbai', 'male', 'cashier@E007', 'Cashier'),
('E008', 'Divya Nair', 9988776655, '1991-02-14', 'divya.nair@example.com', '2021, Juhu, Mumbai', 'female', 'DivyaNair@2024', 'Warehouse Manager'),
('E009', 'Amit Yadav', 9456781234, '1986-12-10', 'amit.yadav@example.com', '2223, Koramangala, Bangalore', 'male', 'Amit@1234', 'Block Incharge'),
('E010', 'Sita Rao', 9123456780, '1994-08-05', 'sita.rao@example.com', '2425, Khar, Mumbai', 'female', 'cashier@E010', 'Block Manager'),
('E011', 'Karan Joshi', 8899876543, '1990-06-20', 'karan.joshi@example.com', '2627, Whitefield, Bangalore', 'male', 'Karan@789', 'Warehouse Manager'),
('E012', 'Neha Kapoor', 8888888888, '1993-10-30', 'neha.kapoor@example.com', '2829, Marine Lines, Mumbai', 'female', 'NehaK@2023', 'Block Incharge'),
('E013', 'Rahul Jain', 9000000000, '1987-11-15', 'rahul.jain@example.com', '3031, Hitech City, Hyderabad', 'male', 'cashier@E013', 'Cashier'),
('E014', 'Geeta Iyer', 9999999999, '1995-03-22', 'geeta.iyer@example.com', '3233, Malleswaram, Bangalore', 'female', 'GeetaIyer456@', 'Warehouse Manager'),
('E015', 'Vivek Saxena', 9988776655, '1984-07-11', 'vivek.saxena@example.com', '3435, Vashi, Navi Mumbai', 'male', 'Vivek@789!', 'Block Incharge'),
('E016', 'Priya Choudhary', 9876543210, '1992-05-03', 'priya.choudhary@example.com', '3637, Jayanagar, Bangalore', 'female', 'cashier@E016', 'Cashier'),
('E017', 'Aakash Bhatt', 9756123487, '1991-09-27', 'aakash.bhatt@example.com', '3839, CP, Delhi', 'male', 'AakashB@2023', 'Warehouse Manager'),
('E018', 'Riya Sethi', 9445566778, '1993-12-05', 'riya.sethi@example.com', '4041, Kharghar, Navi Mumbai', 'female', 'Riya@789!', 'Block Incharge'),
('E019', 'Mohit Patil', 9123456782, '1985-01-16', 'mohit.patil@example.com', '4243, Andheri, Mumbai', 'male', 'cashier@E019', 'Cashier'),
('E020', 'Shalini Kumar', 8789878987, '1990-04-18', 'shalini.kumar@example.com', '4445, Dadar, Mumbai', 'female', 'Shalini@2023', 'Warehouse Manager'),
('E021', 'Suresh Rani', 9191919191, '1986-08-22', 'suresh.rani@example.com', '4647, Kalyan, Mumbai', 'male', 'SureshRani456!', 'Block Incharge'),
('E022', 'Nisha Singh', 8654321098, '1992-02-28', 'nisha.singh@example.com', '4849, Malad, Mumbai', 'female', 'cashier@E022', 'Cashier'),
('E023', 'Ajay Verma', 9345678901, '1987-10-14', 'ajay.verma@example.com', '5051, Goregaon, Mumbai', 'male', 'AjayVerma123!', 'Warehouse Manager'),
('E024', 'Kavita Bhattacharya', 8181818181, '1993-06-12', 'kavita.bhattacharya@example.com', '5253, Bhopal, Madhya Pradesh', 'female', 'Kavita@456', 'Block Incharge'),
('E025', 'Nikhil Yadav', 7878787878, '1988-03-30', 'nikhil.yadav@example.com', '5455, Kanpur, Uttar Pradesh', 'male', 'cashier@E025', 'Cashier'),
('E026', 'Meera Reddy', 8585858585, '1990-09-19', 'meera.reddy@example.com', '5657, Surat, Gujarat', 'female', 'Meera@789!', 'Warehouse Manager'),
('E027', 'Siddharth Ghosh', 6464646464, '1994-11-05', 'siddharth.ghosh@example.com', '5859, Jaipur, Rajasthan', 'male', 'Siddharth@456', 'Block Incharge'),
('E028', 'Suman Rao', 6767676767, '1985-07-24', 'suman.rao@example.com', '6061, Indore, Madhya Pradesh', 'female', 'cashier@E028', 'Cashier'),
('E029', 'Vikrant Singh', 7070707070, '1992-01-20', 'vikrant.singh@example.com', '6263, Nagpur, Maharashtra', 'male', 'Vikrant@789!', 'Warehouse Manager'),
('E030', 'Lata Sharma', 7373737373, '1994-04-05', 'lata.sharma@example.com', '6465, Bhopal, Madhya Pradesh', 'female', 'Lata@456', 'Block Incharge');



INSERT into Block(block_id,block_name,block_incharge_id)
 values
 ('B1','Men Fashion','E002'),
 ('A1','Grocery','E001'),
('A2','Daily Needs','E003'),
('C1','Electronics','E004'),
('C2','Dining & Serving','E005'),
('B2','Women Fashion','E006'),
('B3','Kids Wear','E007'),
('C3','Stationary','E008'),
('B4','Footwear','E009'),
('B5','Watches','E010');

INSERT INTO OfferDetails (offers_id, offers_type, offers_details, offers_start_date, offers_end_date) VALUES
    ('BARGAINBASKET', 'Supermarket Flash Sale', 'Grab up to 5% off on daily essentials like rice, pulses & spices!', '2024-11-01', '2024-11-15'),
    ('INSTAMUNCH', 'Social Media Challenge', 'Post your shopping haul on Instagram & win a ₹15 gift voucher!', '2024-11-05', '2024-11-20'),
    ('DIWALIDELIGHTS', 'Festive Offer', 'Buy sweets & snacks, get an extra 10% off! #DiwaliDelights', '2024-11-01', '2024-11-15'),
    ('PAYTMEXTRA', 'Cashback Bonanza', 'Use Paytm to pay and get 5% cashback on your grocery bill!', '2024-11-01', '2024-11-30'),
    ('FLASHFEST', 'Limited Time Deal', '20% off on fresh fruits & veggies, 1 hour flash sale every day at 5PM!', '2024-11-05', '2024-11-20'),
    ('BILLTWEET', 'Social Media Special', 'Tweet about your shopping experience and get ₹30 off on next purchase!', '2024-11-05', '2024-11-25'),
    ('KHUSIWALIDIWALI', 'Diwali offer', '10% discount on spend above ₹1000 during Diwali celebrations!', '2024-11-01', '2024-11-10'),
	('WINTERWARMTH', 'Winter Comfort Sale', 'Up to 20% off on winter essentials: blankets, jackets, and more!', '2024-11-01', '2024-12-31'),
    ('NEWYEARNEWDEAL', 'New Year Mega Sale', 'Get up to ₹200 off on all grocery with a minimum of ₹1500 spend!', '2024-12-20', '2024-12-31'),
    ('CASH10', 'Cash payment offer', 'Get 10% off', '2024-11-01', '2024-11-15'),
    ('CREDIT5', 'Credit card offer', 'Upto 5% off', '2024-11-05', '2024-11-20'),
    ('DEBIT5', 'Debit card offer', '20% off on shopping above ₹2000', '2024-11-01', '2024-11-30'),
    ('OFF10','just an offer','meri merji','2024-11-01','2024-11-30');

INSERT INTO CustomerType (type_id, type_name) VALUES
('CT00S', 'Silver Shopper'),
('CT00G', 'Gold Member'),
('CT00P', 'Platinum Patron'),
('CT0PR', 'Premium Patron'),
('CT1BR', 'Bargain Hunter'),
('CT1EX', 'Exclusive Elite'),
('CT1VIP', 'VIP Shopper'),
('CT1FAM', 'Family Club'),
('CT1DEL', 'Delivery Pro'),
('CT1REW', 'Rewards Seeker');

INSERT INTO Customer (customer_id, customer_name, customer_contact, date_of_birth, email, address, gender, customer_type_id, membership_to, membership_to_from) VALUES
('230001001', 'Mahesh Kumar', '96548245', '2000-11-23', 'maheshpunk@gmail.com', 'Rohini', 'male', 'CT00S', '2025-12-10', '2024-12-10'),
('230001002', 'Rakesh Verma', '96545489', '1998-07-13', 'rakeshrap@gmail.com', 'Connaught Place', 'male', 'CT00G', '2026-05-17', '2024-05-17'),
('230001003', 'Shanti Sharma', '86544759', '1996-10-28', 'shanti203@gmail.com', 'Pitampura', 'female', 'CT00G', '2026-12-05', '2024-12-05'),
('230001004', 'Vimla Patel', '92512549', '1994-10-11', 'vimlakanti@gmail.com', 'India Gate', 'female', 'CT00P', '2025-07-10', '2023-07-10'),
('230001005', 'Ahmad Khan', '84824589', '2000-09-11', 'ahmadkhan11@gmail.com', 'Pragati Maidan', 'male', 'CT00S', '2025-10-15', '2024-10-15'),
('230001006', 'Vikash Gupta', '96618554', '1998-02-13', 'vikashhero@gmail.com', 'Rohini', 'male', 'CT00S', '2025-11-11', '2024-11-11'),
('230001007', 'Kalika Joshi', '87521452', '2001-12-22', 'kalikaomg@gmail.com', 'Dwarka', 'female', 'CT00S', '2025-08-05', '2024-08-05'),
('230001008', 'Karan Mehra', '80821452', '1991-10-20', 'karank102@gmail.com', 'Connaught Place', 'male', 'CT0PR', '2027-09-26', '2024-09-26'),
('230001009', 'Vipul Singh', '88548887', '1992-03-29', 'singhvipul@gmail.com', 'Noida', 'male', 'CT0PR', '2028-06-15', '2025-06-15'),
('230001010', 'Akhilesh Sharma', '94547212', '2000-10-23', 'akhilesh887@gmail.com', 'Rohini', 'male', 'CT00S', '2025-12-10', '2024-12-10'),
('230001011', 'Raman Yadav', '91541587', '1998-09-13', 'ramanji87p@gmail.com', 'Connaught Place', 'male', 'CT00G', '2026-05-17', '2024-05-17'),
('230001012', 'Sita Rani', '76524775', '1996-12-28', 'sita5487@gmail.com', 'Pitampura', 'female', 'CT00G', '2026-12-05', '2024-12-05'),
('230001013', 'Kavita Singh', '95812573', '1994-11-11', 'kvgood12@gmail.com', 'India Gate', 'female', 'CT00P', '2025-07-10', '2023-07-10'),
('230001014', 'Vijay Sharma', '94584581', '2000-10-11', 'vijay11@gmail.com', 'Pragati Maidan', 'male', 'CT00S', '2025-10-15', '2024-10-15'),
('230001015', 'Kamlesh Kumar', '98624774', '1998-01-13', 'kamk78@gmail.com', 'Rohini', 'male', 'CT00S', '2025-11-11', '2024-11-11'),
('230001016', 'Radha Joshi', '97548475', '2001-10-22', 'radhakrishna09@gmail.com', 'Dwarka', 'female', 'CT00S', '2025-08-05', '2024-08-05'),
('230001017', 'Manish Kapoor', '92821112', '1991-12-20', 'manimonk102@gmail.com', 'Connaught Place', 'male', 'CT0PR', '2027-09-26', '2024-09-26'),
('230001018', 'Prem Kumar', '89821845', '1992-01-28', 'prempuri41@gmail.com', 'Noida', 'male', 'CT0PR', '2028-06-17', '2025-06-17'),
('230001019', 'Ghanshyam Gupta', '89821845', '1993-01-28', 'gnm00841@gmail.com', 'Noida', 'male', 'CT0PR', '2028-06-17', '2025-06-17'),
('230001020', 'Manoj Rai', '89221845', '1990-02-18', 'manoj2541@gmail.com', 'Noida', 'male', 'CT0PR', '2028-06-17', '2025-06-17'),
('230001021', 'Prashant Sharma', '89821445', '1995-01-28', 'pc41@gmail.com', 'Punjabi Bagh', 'male', 'CT00S', '2025-06-17', '2024-06-17'),
('230001022', 'Biswas Kumar', '89821841', '1990-11-28', 'biswas41@gmail.com', 'Noida', 'male', 'CT0PR', '2028-06-17', '2025-06-17'),
('230001023', 'Ajay Rathi', '89821995', '1994-11-08', 'ajay41@gmail.com', 'Noida', 'male', 'CT0PR', '2028-06-17', '2025-06-17'),
('230001024', 'Hemaant Sharma', '89811845', '1993-03-28', 'hmoi41@gmail.com', 'Noida', 'male', 'CT0PR', '2028-06-17', '2025-06-17'),
('230001025', 'Jayesh Mehta', '89833345', '1990-04-23', 'jayesh401@gmail.com', 'Noida', 'male', 'CT00S', '2025-06-17', '2024-06-17'),
('230001026', 'Bhawesh Arora', '89833315', '1991-04-23', 'bhawesh411@gmail.com', 'Noida', 'male', 'CT00S', '2025-06-17', '2024-06-17'),
('230001027', 'Keyur Patil', '89133345', '1990-05-13', 'keyur401@gmail.com', 'Noida', 'male', 'CT00S', '2025-06-17', '2024-06-17'),
('230001028', 'Rayesh Khatri', '89832245', '1989-01-23', 'rayesh301@gmail.com', 'Rohini', 'male', 'CT00S', '2025-06-17', '2024-06-17');

INSERT INTO Warehouse (warehouse_no, warehouse_name) VALUES
('WARA001', 'Central Warehouse'),
('WARA002', 'North Zone Warehouse'),
('WARA003', 'South Zone Warehouse'),
('WARB001', 'East Zone Warehouse'),
('WARB002', 'West Zone Warehouse'),
('WARC001', 'Northwest Warehouse'),
('WARC002', 'Southeast Warehouse'),
('WARC003', 'Southwest Warehouse');

INSERT INTO Block (block_id, block_name, block_incharge_id) VALUES
('A3', 'Grocery Essentials', 'E001'),
('B1', 'Men\'s Fashion', 'E002'),
('A2', 'Daily Essentials', 'E003'),
('C1', 'Electronics & Gadgets', 'E004'),
('C2', 'Dining & Kitchenware', 'E005'),
('B2', 'Women\'s Fashion', 'E006'),
('B3', 'Kids Clothing', 'E007'),
('C3', 'Stationery & Books', 'E008'),
('B4', 'Footwear & Accessories', 'E009'),
('B5', 'Watches & Jewelry', 'E010');

INSERT INTO Category (category_id, category_name, store_id, warehouse_no) VALUES
    ('GRO001', 'Fresh Fruits & Veggies', 'A1', 'WARA001'),
    ('GRO002', 'Premium Spices', 'A1', 'WARB001'),
    ('GRO003', 'Healthy Dry Fruits', 'A1', 'WARC003'),
    ('GRO004', 'Organic Rice & Pulses', 'A1', 'WARC002'),
    ('GRO005', 'Cold-Pressed Oils', 'A1', 'WARB001'),
    ('DN001', 'Soaps & Laundry Essentials', 'A2', 'WARC001'),
    ('DN002', 'Beverages & Coffee', 'A2', 'WARB002'),
    ('DN003', 'Luxury Fragrances', 'A2', 'WARC001'),
    ('MF001', 'Men\'s Casual Shirts', 'B1', 'WARA003'),
    ('MF002', 'Stylish Men\'s Trousers', 'B1', 'WARC002'),
    ('MF003', 'Comfortable Men\'s Innerwear', 'B1', 'WARB001'),
    ('WF001', 'Women\'s Trendy Tops', 'B2', 'WARC002'),
    ('WF002', 'Chic Women\'s Jeans', 'B2', 'WARB002'),
    ('WF003', 'Traditional Women\'s Kurti', 'B2', 'WARC001'),
    ('WF004', 'Elegant Lingerie', 'B2', 'WARA002'),
    ('KW001', 'Fashionable Kids Tops', 'B3', 'WARC003'),
    ('KW002', 'Comfortable Baby Jeans', 'B3', 'WARB002'),
    ('KW003', 'Kids Ethnic Wear', 'B3', 'WARC002'),
    ('FW001', 'Men\'s Footwear Collection', 'B4', 'WARC001'),
    ('FW002', 'Women\'s Stylish Footwear', 'B4', 'WARB001'),
    ('FW003', 'Kids\' Footwear', 'B4', 'WARA002'),
    ('CLK001', 'Men\'s Luxury Watches', 'B5', 'WARA003'),
    ('CLK002', 'Women\'s Elegant Watches', 'B5', 'WARA002'),
    ('CLK003', 'Kids\' Fun Watches', 'B5', 'WARA001'),
    ('ELC001', 'Smartphones & Gadgets', 'C1', 'WARC001'),
    ('ELC002', 'Tablets & E-Readers', 'C1', 'WARB002'),
    ('ELC003', 'Powerful Laptops', 'C1', 'WARC002'),
    ('ELC004', 'LED TVs & Home Entertainment', 'C1', 'WARA001'),
    ('ELC005', 'Speakers, Woofer & MP3 Players', 'C1', 'WARA001'),
    ('DNG001', 'Dining & Tableware', 'C2', 'WARA001'),
    ('DNG002', 'Storage Solutions', 'C2', 'WARC003'),
    ('DNG003', 'Kitchen Essentials', 'C2', 'WARC001'),
    ('DNG004', 'Cooking Tools & Gadgets', 'C2', 'WARA003'),
    ('STN001', 'Office Stationery', 'C3', 'WARA002'),
    ('STN002', 'Notebooks & Diaries', 'C3', 'WARA003'),
    ('STN003', 'Craft & Art Supplies', 'C3', 'WARB001'),
    ('STN004', 'Pens & Writing Instruments', 'C3', 'WARC001');


INSERT INTO PaymentMode (payment_mode_id, mode_of_payment, offer_id) VALUES
    ('PAY001', 'Cash Payment', 'CASH10'),
    ('PAY002', 'Credit Card Payment', 'CREDIT5'),
    ('PAY003', 'Debit Card Payment', 'DEBIT5'),
    ('PAY004', 'Paytm Wallet', 'PAYTMEXTRA');
INSERT INTO InvoiceDetails (inv_id,cust_id,amount,inv_date,cashier_id)VALUES
('001','230001001','5000.223','2017-04-01', 'E001'),
('002','230001002','455000.11','2017-04-01', 'E003'),
('003','230001003','9865.22','2017-04-01', 'E004'),
('004','230001004','8000.25','2015-03-05', 'E002'),
('005','230001005','56666.22','2014-03-05', 'E005'),
('006','230001006','7889.42','2014-02-15', 'E006'),
('007','230001007','9999.88','2017-02-15','E005'),
('008','230001008','7852.88','2017-02-15','E005'),
('009','230001009','400.88','2017-01-15','E002'),
('010','230001010','52224.88','2017-01-15', 'E001'),
('011','230001011','6655.88','2017-01-15','E004'),
('012','230001012','488.88','2016-12-30','E003'),
('013','230001013','300.88','2016-12-30','E002'),
('014','230001014','400.88','2015-01-15','E002'),
('015','230001015','52224.88','2015-01-15','E001'),
('016','230001016','6655.88','2016-01-15','E004'),
('017','230001017','488.88','2016-03-30','E003'),
('018','230001018','3000.88','2016-04-30','E002'),
('019','230001001','6000.223','2017-05-01','E001'),
('020','230001007','495000.11','2017-04-29','E003');

select * from InvoiceDetails;
    INSERT INTO Product (product_id, product_type, brand, cost_price, weight, selling_price, category_id, offer_id, block_count, warehouse_count) 
VALUES 
    ('PI10001', 'Apple', 'CASCADIAN FARM', 270, '1kg', 320, 'GRO001', 'BARGAINBASKET', 500, 300),
    ('PI10002', 'Banana', 'HARVEST FARM', 36, '1kg', 44, 'GRO001', 'BARGAINBASKET', 200, 100),
    ('PI10003', 'Orange', '365 ORGANIC', 180, '1kg', 210, 'GRO001', 'BARGAINBASKET', 300, 200),
    ('PI10004', 'Brinjal', 'MARKET SIDE', 36, '1kg', 42, 'GRO001', 'BARGAINBASKET', 100, 50),
    ('PI10005', 'Potato', 'MARKET SIDE', 18, '1kg', 22, 'GRO001', 'BARGAINBASKET', 100, 50),
    ('PI10011', 'turmeric', 'EVEREST', 45, '0.05kg', 50, 'GRO002', 'BARGAINBASKET', 100, 200),
    ('PI10012', 'chilli powder', 'EVEREST', 36, '0.05kg', 45, 'GRO002', 'BARGAINBASKET', 100, 200),
    ('PI10013', 'Salt', 'TATA', 18, '1 kg', 22, 'GRO002', 'BARGAINBASKET', 200, 100),
    ('PI10014', 'Chicken Masala', 'EVEREST', 36, '0.1kg', 43, 'GRO002', 'BARGAINBASKET', 100, 150),
     ('PI10021', 'walnut', 'sunsweet', 450, '0.25kg', 500, 'GRO003', 'BARGAINBASKET', 100, 200),
    ('PI10022', 'cashew', 'Tulsi', 360, '0.25kg', 400, 'GRO003', 'BARGAINBASKET', 100, 200),
    ('PI10023', 'apricot', 'delicious', 180, '0.5kg', 200, 'GRO003', 'BARGAINBASKET', 200, 100),
    ('PI10024', 'coconut', 'balaji', 36, '0.25kg', 40, 'GRO003', 'BARGAINBASKET', 100, 150),
    ('PI10031', 'rice', 'India Gate', 90, '1kg', 95, 'GRO004', 'BARGAINBASKET', 200, 300),
    ('PI10032', 'brown rice', 'fabindia', 72, '1kg', 68.4, 'GRO004', 'BARGAINBASKET', 300, 200),
    ('PI10033', 'wheat', 'aashirwad', 27, '1kg', 30, 'GRO004', 'BARGAINBASKET', 400, 200),
    ('PI10034', 'Urad daal', 'balaji', 108, '1kg', 120, 'GRO004', 'BARGAINBASKET', 300, 250),
    ('PI10041', 'soyabean oil', 'fortune', 90, '1kg', 110, 'GRO005', 'BARGAINBASKET', 100, 100),
    ('PI10042', 'canola oil', 'saffola', 135, '1kg', 155, 'GRO005', 'BARGAINBASKET', 50, 100),
    ('PI10043', 'mustard oil', 'nature fresh', 117, '1kg', 130, 'GRO005', 'BARGAINBASKET', 200, 100),
    ('PI10044', 'sunflower oil', 'nutrela', 108, '1kg', 120, 'GRO005', 'BARGAINBASKET', 100, 110),
	('PI10081', 'body soap', 'cinthol', 36, '0.05kg', 45, 'DN001', 'BARGAINBASKET', 200, 100),
    ('PI10082', 'cloth soap', 'XXX', 18, '0.05kg', 20, 'DN001', 'BARGAINBASKET', 300, 100),
    ('PI10083', 'detergent', 'surf excel', 117, '0.5kg', 130, 'DN001', 'BARGAINBASKET', 100, 100),
    ('PI10084', 'floor cleaner', 'lizol', 54, '1kg', 60, 'DN001', 'BARGAINBASKET', 70, 50),
    ('PI10091', 'tea', 'Gemini', 36, '0.05kg', 40, 'DN002', 'BARGAINBASKET', 200, 100),
    ('PI10092', 'coffee', 'nescafe', 126, '0.05kg', 140, 'DN002', 'BARGAINBASKET', 350, 100),
    ('PI10093', 'Cappuccino', 'Bru', 117, '0.5kg', 130, 'DN002', 'BARGAINBASKET', 100, 100),
    ('PI10094', 'leaf-tea', 'lipton', 54, '0.05kg', 60, 'DN002', 'BARGAINBASKET', 200, 160),
    ('PI10101', 'perfume', 'Fogg', 360, '0.15kg', 449, 'DN003', 'FLASHFEST', 200, 100),
    ('PI10102', 'deodrant', 'axe', 126, '0.15kg', 149, 'DN003', 'FLASHFEST', 350, 100),
    ('PI10103', 'room freshner', 'odonil', 117, '0.15kg', 139, 'DN003', 'FLASHFEST', 100, 100),
	('PI10111', 'shirt', 'mufti', 1260, '1', 1399, 'MF001', 'INSTAMUNCH', 200, 100),
    ('PI10112', 'half sleeve', 'lee', 1170, '1', 1299, 'MF001', 'INSTAMUNCH', 350, 100),
    ('PI10113', 't-shirt', 'jack and jones', 1080, '1', 1199, 'MF001', 'INSTAMUNCH', 100, 100),
    ('PI10121', 'jeans', 'mufti', 1260, '1', 1499, 'MF002', 'BILLTWEET', 200, 100),
    ('PI10122', 'trousers', 'lee', 1170, '1', 1149, 'MF002', 'BILLTWEET', 350, 100),
    ('PI10123', 'formal', 'blackberry', 1080, '1', 1999, 'MF002', 'BILLTWEET', 100, 100),
    ('PI10131', 'banyan', 'Jockey', 126, '1', 249, 'MF003', 'PAYTMEXTRA', 60, 100),
    ('PI10132', 'underwear', 'Jockey', 125, '1', 249, 'MF003', 'PAYTMEXTRA', 50, 100),
    ('PI10133', 'handkerchief', 'blackberry', 90, '1', 149, 'MF003', 'INSTAMUNCH', 50, 100),
    ('PI10134', 'socks', 'Jockey', 90, '1', 200, 'MF003', 'PAYTMEXTRA', 50, 100),
     ('PI10141', 'full sleeve top', 'Calvin Klein', 1260, '1', 1699, 'WF001', 'INSTAMUNCH', 60, 100),
    ('PI10142', 'half sleeve top', 'Calvin Klein', 540, '1', 799, 'WF001', 'INSTAMUNCH', 50, 100),
    ('PI10143', 'sleeveless', 'Jockey', 990, '1', 1499, 'WF001', 'INSTAMUNCH', 50, 100),
    ('PI10144', 'formal', 'Blackberry', 990, '1', 1100, 'WF001', 'INSTAMUNCH', 50, 100),
    ('PI10151', 'formal pant', 'Blackberry', 1260, '1', 1400, 'WF002', 'BILLTWEET', 200, 100),
    ('PI10152', 'trousers', 'Peter England', 1170, '1', 1399, 'WF002', 'BILLTWEET', 350, 100),
    ('PI10153', 'formal', 'Peter England', 1080, '1', 1299, 'WF002', 'BILLTWEET', 100, 100),
    ('PI10161', 'banyan', 'Dollar', 126, '1', 169, 'WF004', 'FLASHFEST', 60, 100),
    ('PI10162', 'underwear', 'Dollar', 225, '1', 149, 'WF004', 'FLASHFEST', 50, 100),
    ('PI10163', 'handkerchief', 'Levis', 90, '1', 130, 'WF004', 'FLASHFEST', 50, 100),
    ('PI10164', 'socks', 'Dollar', 90, '1', 150, 'WF004', 'FLASHFEST', 50, 100),
    ('PI10165', 'BRA', 'Dollar', 180, '1', 199, 'WF004', 'FLASHFEST', 50, 100),
    ('PI10171', 'top', 'Allen Solly', 360, '1', 449, 'KW001', 'INSTAMUNCH', 80, 100),
    ('PI10172', 'lower', 'Allen Solly', 270, '1', 349, 'KW001', 'INSTAMUNCH', 80, 100),
    ('PI10173', 'combo', 'Allen Solly', 600, '1', 700, 'KW001', 'INSTAMUNCH', 80, 100),
    ('PI10181', 'half jeans', 'Champion', 450, '1', 500, 'KW002', 'INSTAMUNCH', 60, 100),
    ('PI10182', 'full jeans', 'Champion', 720, '1', 800, 'KW002', 'INSTAMUNCH', 70, 100),
    ('PI10183', 'trouser', 'Champion', 810, '1', 900, 'KW002', 'INSTAMUNCH', 90, 100),
    ('PI10191', 'Kurata-Payzama', 'Bad-boys', 900, '1', 1000, 'KW003', 'INSTAMUNCH', 70, 100),
    ('PI10192', 'Top-Skirt', 'Biba', 540, '1', 600, 'KW003', 'INSTAMUNCH', 40, 100),
    ('PI10193', 'Sherwani', 'Gkidz', 720, '1', 800, 'KW003', 'INSTAMUNCH', 60, 100),
    ('PI10194', 'Lehenga-choli', 'Biba', 1350, '1', 1500, 'KW003', 'INSTAMUNCH', 90, 100),
     ('PI10201', 'Sneakers', 'Levis', 1350, '1', 1500, 'FW001', 'PAYTMEXTRA', 70, 100),
    ('PI10202', 'Loafers', 'Nike', 1125, '1', 1500, 'FW001', 'DEBIT5', 60, 100),
    ('PI10203','Casual Shoes','Reebok','1700','1','2000','FW001','CASH10','50','100'),
    ('PI10204','Formal Shoes','Columbus','2500','1','3000','FW001','CASH10','90','100'),
    ('PI10205','Flip-flops','Puma','225','1','500','FW001','PAYTMEXTRA','30','100'),
    ('PI10206','Floaters','Adidas','900','1','1500','FW001','PAYTMEXTRA','40','100'),

    ('PI10211','Wedges','Lavie','3150','1','3500','FW002','OFF10','70','100'),
('PI10212','Heels','Catwalk','2250','1','2500','FW002','OFF10','90','100'),
('PI10213','Casual Shoes','Reebok','1620','1','1800','FW002','OFF10','50','100'),
('PI10214','Ballerians','Bata','1350','1','1500','FW002','OFF10','80','100'),
('PI10215','Flip-flops','Action','150','1','200','FW002','PAYTMEXTRA','30','100'),
('PI10216','Floaters','Sparx','900','1','1200','FW002','PAYTMEXTRA','40','100'),

('PI10221','Sandals','Puma','720','1','800','FW003','OFF10','70','100'),
('PI10222','Shoes','Action-campus','900','1','1000','FW003','OFF10','90','100'),
('PI10223','Flip-flops','Bata','180','1','200','FW003','OFF10','50','100'),

('PI10301','Digital','Fastrack','4250','1','5000','CLK001','DEBIT5','80','100'),
('PI10302','Analogue','Sonata','2550','1','3000','CLK001','DEBIT5','70','100'),
('PI10303','Analogue','HMT','1350','1','1500','CLK001','OFF10','80','100'),
('PI10304','Analogue','Titan','3400','1','4000','CLK001','CREDIT5','60','100'),
('PI10305','Digital','Timex','1500','1','2000','CLK001','CREDIT5','50','100'),

('PI10311','Digital','Reebok','2250','1','2500','CLK002','OFF10','90','100'),
('PI10312','Analogue','Maxima','1800','1','2000','CLK002','OFF10','50','100'),
('PI10313','Analogue','Titan','3750','1','5000','CLK002','OFF10','80','100'),
('PI10314','Analogue','Sonata','1530','1','1800','CLK002','KHUSIWALIDIWALI','30','100'),

('PI10321','Digital','Zoop','1080','1','1200','CLK003','OFF10','90','100'),
('PI10322','Analogue','Sonata','950','1','1000','CLK003','KHUSIWALIDIWALI','50','100'),
('PI10323','Digital','Fastrack','1350','1','1500','CLK003','OFF10','80','100'),

('PI10601','Highlighter','Faber-castle','45','1','50','STN001','OFF10','90','100'),
('PI10602','Stapler','Kangaroo','95','1','100','STN001','WINTERWARMTH','50','100'),
('PI10603','Pen-stand','GAC','190','1','200','STN001','WINTERWARMTH','80','100'),
('PI10604','A4-paper','JK-Copier','570','1','600','STN001','NEWYEARNEWDEAL','30','100'),
('PI10611','Long-Book','Camlin','90','1','100','STN002','OFF10','20','100'),
('PI10612','Notebook','Classmate','45','1','50','STN002','OFF10','50','100'),
('PI10613','Writing-board','FfUuNn','108','1','120','STN002','OFF10','70','100'),
('PI10614','Scrapbook','Navneet','57','1','60','STN002','WINTERWARMTH','80','100'),

('PI10621','Wax crayons','Camlin','18','1','20','STN003','OFF10','20','100'),
('PI10622','Fevicol','Pidilite','180','1','200','STN003','OFF10','50','100'),
('PI10623','Poster-colors','Camel','135','1','150','STN003','OFF10','70','100'),
('PI10624','Paper-cutter','Faber-castle','57','1','60','STN003','WINTERWARMTH','80','100'),

('PI10631','Gel-pen','Cello','90','10','100','STN004','OFF10','20','100'),
('PI10632','Ballpoint-pen','Flair','45','1','50','STN004','OFF10','50','100'),
('PI10633','Pencils','FfUuNn','45','1','50','STN004','OFF10','70','100'),
('PI10634','Eraser','Navneet','45','1','50','STN004','OFF10','80','100'),



('PI10401','Android phone','samsung','14450','1','15000','ELC001','KHUSIWALIDIWALI','20','20'),
('PI10404','Android phone','samsung','4450','1','5000','ELC001','KHUSIWALIDIWALI','20','20'),
('PI10402','windows','microsoft','7720','1','8000','ELC001','KHUSIWALIDIWALI','20','10'),
('PI10403','IPHONE','apple','38810','1','40000','ELC001','KHUSIWALIDIWALI','10','05'),

('PI10411','Android tablet','MI','12550','1','13000','ELC002','KHUSIWALIDIWALI','20','20'),
('PI10412','Android tablet','micromax','6450','1','7000','ELC002','KHUSIWALIDIWALI','20','20'),
('PI10414','windows','microsoft','9720','1','10000','ELC002','KHUSIWALIDIWALI','20','10'),
('PI10413','ipad','apple','48810','1','50000','ELC002','KHUSIWALIDIWALI','10','05'),

('PI10421','windows based','Acer','42550','1','43000','ELC003','KHUSIWALIDIWALI','20','20'),
('PI10422','windows based','Dell','36450','1','37000','ELC003','KHUSIWALIDIWALI','20','20'),
('PI10424','windows based','lenovo','29720','1','30000','ELC003','KHUSIWALIDIWALI','20','10'),
('PI10423','macbook','apple','47810','1','50000','ELC003','KHUSIWALIDIWALI','10','05'),


('PI10431','40 inch','sony','32550','1','33100','ELC004','KHUSIWALIDIWALI','20','20'),
('PI10432','32 inch','panasonic','26450','1','27200','ELC004','KHUSIWALIDIWALI','20','20'),
('PI10434','premium tv','vu','39720','1','45000','ELC004','KHUSIWALIDIWALI','20','10'),
('PI10433','32 inch','samsung','38810','1','42300','ELC004','KHUSIWALIDIWALI','10','05'),
('PI10441','home theatre','sony','22550','1','23100','ELC005','KHUSIWALIDIWALI','20','20'),
('PI10442','bluetooth speaker','philips','1450','1','1300','ELC005','KHUSIWALIDIWALI','20','20'),
('PI10444','soundbars','philips','19720','1','21000','ELC005','KHUSIWALIDIWALI','20','10'),
('PI10443','ipods','apple','18810','1','19300','ELC005','KHUSIWALIDIWALI','10','05'),

('PI10501','cutlery','uberlyfe','550','1','600','DNG001','KHUSIWALIDIWALI','200','200'),
('PI10502','glasses','godskitchen','450','1','500','DNG001','KHUSIWALIDIWALI','200','120'),
('PI10503','dishware','planet','720','1','800','DNG001','KHUSIWALIDIWALI','200','100'),
('PI10504','trays','woogor','310','1','400','DNG001','KHUSIWALIDIWALI','100','305'),

('PI10511','Jars & Containers ','cello','750','1','800','DNG002','KHUSIWALIDIWALI','120','52'),
('PI10512','lunch boxes','blossoms','250','1','300','DNG002','KHUSIWALIDIWALI','120','20'),
('PI10513','kitchen racks','generic','1020','1','1100','DNG002','KHUSIWALIDIWALI','220','110'),
('PI10514','produce storage bags','bagathon india','610','1','700','DNG002','KHUSIWALIDIWALI','100','105'),

('PI10521','juicer','bajaj','1750','1','1850','DNG003','KHUSIWALIDIWALI','30','12'),
('PI10522','grinder','maharaj','2250','1','2350','DNG003','KHUSIWALIDIWALI','20','10'),
('PI10523','vegetable cutter','prestige','1120','1','1200','DNG003','KHUSIWALIDIWALI','40','10'),
('PI10524','fruit chooper','ganesh','610','1','700','DNG003','KHUSIWALIDIWALI','40','15'),
('PI10531','cooking induction','prystine','1450','1','1550','DNG004','KHUSIWALIDIWALI','30','12'),
('PI10532','presssure cooker','prestige','1250','1','1350','DNG004','KHUSIWALIDIWALI','20','10'),
('PI10533','cooking pots','king','420','1','500','DNG004','KHUSIWALIDIWALI','40','10'),
('PI10534','casserole set','pristine','1010','1','1100','DNG004','KHUSIWALIDIWALI','40','15');


CREATE TABLE buys_products (
    product_name VARCHAR(255) NOT NULL,
    quantity INT NOT NULL,
    price float NOT NULL,
    temp_flag int
);


DELIMITER $$

CREATE TRIGGER after_insert_invoice_details
AFTER INSERT ON InvoiceDetails
FOR EACH ROW
BEGIN
    
    INSERT INTO buys (product_name, invoice_id, quantity, cost)
    SELECT
        bp.product_name,
        NEW.inv_id,
        bp.quantity,
        bp.price * bp.quantity
    FROM buys_products bp
    WHERE bp.temp_flag = 1; 


    UPDATE buys_products
    SET temp_flag = 0
    WHERE temp_flag = 1;
END$$

DELIMITER ;



INSERT INTO buys_products (product_name, quantity,price)
VALUES ('Apple', 10, 15.00),
       ('Banana', 5, 10.00);


INSERT INTO InvoiceDetails (inv_id,cust_id,amount,inv_date,cashier_id)VALUES
('007','230001001','495000.11','2017-04-29','E003');

select * from buys;
drop database supermarket_db;
    
    truncate table Product;
    
    DROP TABLE buys_products;
    select * from InvoiceDetails;
    select * from buys_products;
    
    SET SQL_SAFE_UPDATES = 0;

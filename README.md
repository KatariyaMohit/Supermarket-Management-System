# Supermarket-Management-System
The Supermarket Management System is a role-based web application designed to manage day-to-day supermarket operations including billing, inventory, employee management, and warehouse logistics. It ensures smooth coordination between admin, cashier, warehouse manager, and block in-charges through an integrated MySQL database and Flask backend.

A full-featured web-based supermarket management system built with Flask, MySQL, and HTML/CSS/JavaScript. This system is designed to handle everything from employee and product management to real-time billing, stock tracking, warehouse transfers, and email invoicing.

## Features :-
### Role-Based Login System 
Admin – Full access to all modules (CRUD on all tables).
Cashier – Customer billing, invoice generation, email bills.
Warehouse Manager – Manages inventory at warehouse & block levels.
Block In-Charge – Oversees stock availability in their assigned block.

## Intelligent Operations
Auto-suggest customer names during billing.
Real-time product availability tracking.
Offer/discount integration into bill generation.
Email functionality to send invoices directly to customers.

## Database Tables (supermarket_db)
employee, customer, customertype, product, category, warehouse, block, producttransferhisto, offerdetails, buys, buys_products, invoicedetails, feedback, complaints, returnslip, paymentmode

## Tech Stack
Backend: Python (Flask)
Frontend: HTML, CSS, JavaScript (Jinja templates)
Database: MySQL
Emailing: Flask-Mail (SMTP-based)
Authentication: Role-based session management

## Folder Structure
├── app.py                # Main backend logic
├── supermarket_db.sql    # MySQL database schema and seed data
├── static/               # CSS, JS, images
├── templates/            # HTML (Jinja2 templating)
└── README.md             # Project documentation


# Setup Instructions :-

## Prerequisites
Python 3.8+
MySQL 5.7+
pip package manager

## Clone the Repository
git clone https://github.com/KatariyaMohit/supermarket-management-system.git
cd supermarket-management-system

## Set Up MySQL Database
Open MySQL and run:
supermarket_db.sql

## Configure app.py
Inside app.py, update:
app.config['MYSQL_USER'] = 'your_db_user'
app.config['MYSQL_PASSWORD'] = 'your_db_password'
app.config['MYSQL_DB'] = 'supermarket_db'
app.secret_key = 'your_secret_key'

app.config['MAIL_USERNAME'] = 'your_email@gmail.com'
app.config['MAIL_PASSWORD'] = 'your_app_password'

## Install Dependencies
pip install flask flask-mysqldb flask-mail
Run the Application 
python app.py 

Access at: http://127.0.0.1:5000 



# User Roles & Capabilities
Role	        - Permissions
Admin	        - Add/edit/delete employees, products, customers, categories, offers, etc.
Cashier	        - Billing, invoice generation, email/send bills, add customers on the fly
Warehouse Mgr	- Manage warehouse inventory, transfer stock to blocks, raise complaints
Block In-Charge	- Monitor and report block-level inventory

# Feedback & Complaints
Customers can submit feedback after billing.
Warehouse managers can raise complaints for damaged/defective products.

# Acknowledgments :-
Flask community for the excellent framework
MySQL for robust database solutions
All contributors who helped improve this system
Built as part of a practical learning project on full-stack web development and database systems.

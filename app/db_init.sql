-- ===========================================================
-- 🛒 E-COMMERCE DOMAIN
-- ===========================================================
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    city TEXT NOT NULL,
    country TEXT NOT NULL
);

CREATE TABLE products (
    product_id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    price NUMERIC NOT NULL
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE NOT NULL
);

CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id TEXT REFERENCES products(product_id),
    quantity INT NOT NULL
);

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    amount NUMERIC NOT NULL,
    payment_date DATE NOT NULL
);

INSERT INTO customers (name, city, country) VALUES
('Alice', 'Toronto', 'Canada'),
('Bob', 'Montreal', 'Canada'),
('Chloe', 'Toronto', 'Canada'),
('David', 'Calgary', 'Canada'),
('Ella', 'Vancouver', 'Canada');

INSERT INTO products (product_id, name, price) VALUES
('L1', 'Windows Laptop', 1200),
('L2', 'Mac Laptop', 3000),
('P1', 'Samsung Phone', 800),
('P2', 'Google Pixel 8 Phone', 1000),
('P3', 'IPhone 17 Phone', 1030),
('T1', 'Samsung Tablet', 400),
('T2', 'Apple IPad Tablet', 500),
('H1', 'Headphones', 200),
('M1', 'Mouse', 50);

INSERT INTO orders (customer_id, order_date) VALUES
(1, '2025-10-10'),
(2, '2025-10-12'),
(1, '2025-10-15'),
(3, '2025-10-20'),
(4, '2025-10-25'),
(5, '2025-10-30');

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 'L1', 1),
(2, 'T1', 2),
(3, 'P1', 1),
(4, 'M1', 3),
(5, 'H1', 1),
(6, 'L2', 1);

INSERT INTO payments (order_id, amount, payment_date) VALUES
(1, 1200, '2025-10-11'),
(2, 800, '2025-10-13'),
(3, 800, '2025-10-16'),
(4, 150, '2025-10-21'),
(5, 200, '2025-10-26'),
(6, 3000, '2025-10-30');

-- ===========================================================
-- 🧳 HR / TRAVEL DOMAIN
-- ===========================================================
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    department TEXT NOT NULL,
    role TEXT NOT NULL
);

CREATE TABLE travel_records (
    travel_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    destination TEXT NOT NULL,
    destination_type TEXT NOT NULL,
    country TEXT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    purpose TEXT NOT NULL,
    cost NUMERIC
);

CREATE TABLE expenses (
    expense_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    description TEXT NOT NULL,
    amount NUMERIC NOT NULL,
    date DATE NOT NULL
);

INSERT INTO employees (name, department, role) VALUES
('Sarah', 'Engineering', 'Software Engineer'),
('Liam', 'Marketing', 'Campaign Manager'),
('Noah', 'Finance', 'Analyst'),
('Olivia', 'Sales', 'Account Executive'),
('Emma', 'Engineering', 'Data Scientist');

INSERT INTO travel_records (employee_id, destination, country, destination_type, start_date, end_date, purpose, cost) VALUES
(1, 'New York', 'USA', 'international', '2025-05-01', '2025-05-05', 'Conference', 1200),
(2, 'Paris', 'France', 'international', '2025-06-10', '2025-06-18', 'Client Visit', 2800),
(3, 'Toronto', 'Canada', 'domestic', '2025-07-01', '2025-07-03', 'Audit', 600),
(4, 'Tokyo', 'Japan', 'international', '2025-08-12', '2025-08-20', 'Sales Meeting', 3400),
(5, 'Berlin', 'Germany', 'international', '2025-09-01', '2025-09-07', 'AI Workshop', 2100);

-- ===========================================================
-- 🏢 OPERATIONS & ASSETS DOMAIN
-- ===========================================================
CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    location TEXT NOT NULL
);

CREATE TABLE assets (
    asset_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    dept_id INT REFERENCES departments(dept_id),
    purchase_date DATE NOT NULL,
    cost NUMERIC NOT NULL,
    status TEXT NOT NULL
);

CREATE TABLE maintenance (
    maintenance_id SERIAL PRIMARY KEY,
    asset_id INT REFERENCES assets(asset_id),
    last_check DATE NOT NULL,
    next_due DATE NOT NULL,
    technician TEXT NOT NULL
);

INSERT INTO departments (name, location) VALUES
('Engineering', 'Toronto'),
('Sales', 'Vancouver'),
('Finance', 'Montreal'),
('Operations', 'Calgary');

INSERT INTO assets (name, dept_id, purchase_date, cost, status) VALUES
('3D Printer', 1, '2024-03-01', 8000, 'Active'),
('Sales Van', 2, '2022-08-12', 35000, 'Active'),
('Server Rack', 3, '2023-02-20', 12000, 'Active'),
('Forklift', 4, '2020-11-15', 20000, 'Maintenance');

INSERT INTO maintenance (asset_id, last_check, next_due, technician) VALUES
(1, '2025-05-01', '2025-11-01', 'Michael'),
(2, '2025-04-10', '2025-10-10', 'Elena'),
(3, '2025-03-15', '2025-09-15', 'Aiden'),
(4, '2024-12-01', '2025-06-01', 'Lucas');

-- ===========================================================
-- 🎓 LEARNING & PERFORMANCE DOMAIN
-- ===========================================================
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    category TEXT NOT NULL,
    duration_days INT NOT NULL
);

CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    course_id INT REFERENCES courses(course_id),
    start_date DATE NOT NULL,
    completion_date DATE
);

CREATE TABLE performance_reviews (
    review_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    review_date DATE NOT NULL,
    rating INT,
    comments TEXT
);

INSERT INTO courses (title, category, duration_days) VALUES
('Python for Data Science', 'Technical', 5),
('Leadership Essentials', 'Management', 3),
('Financial Modeling', 'Finance', 4),
('Customer Success', 'Sales', 2);

INSERT INTO enrollments (employee_id, course_id, start_date, completion_date) VALUES
(1, 1, '2025-03-01', '2025-03-06'),
(2, 4, '2025-04-10', '2025-04-12'),
(5, 1, '2025-05-01', '2025-05-05'),
(3, 3, '2025-02-20', '2025-02-25');

INSERT INTO performance_reviews (employee_id, review_date, rating, comments) VALUES
(1, '2025-06-01', 5, 'Excellent performance'),
(2, '2025-06-05', 4, 'Strong project delivery'),
(3, '2025-06-10', 3, 'Needs improvement in deadlines'),
(4, '2025-06-15', 5, 'Exceeded targets');

-- ===========================================================
-- 🌎 SUPPLY CHAIN DOMAIN
-- ===========================================================
CREATE TABLE vendors (
    vendor_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    country TEXT NOT NULL
);

CREATE TABLE shipments (
    shipment_id SERIAL PRIMARY KEY,
    vendor_id INT REFERENCES vendors(vendor_id),
    product_id TEXT REFERENCES products(product_id),
    quantity INT NOT NULL,
    shipment_date DATE NOT NULL
);

CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    product_id TEXT REFERENCES products(product_id),
    stock_level INT NOT NULL,
    last_updated DATE NOT NULL
);

INSERT INTO vendors (name, country) VALUES
('TechSource', 'USA'),
('MobileWorld', 'China'),
('EuroElectro', 'Germany');

INSERT INTO shipments (vendor_id, product_id, quantity, shipment_date) VALUES
(1, 'L1', 100, '2025-09-10'),
(2, 'P1', 200, '2025-09-12'),
(3, 'H1', 150, '2025-09-15');

INSERT INTO inventory (product_id, stock_level, last_updated) VALUES
('L1', 80, '2025-10-01'),
('P1', 150, '2025-10-02'),
('H1', 90, '2025-10-03'),
('M1', 50, '2025-10-04');



-- ===========================================================
-- 📚 TABLE METADATA (semantic layer for the agent)
-- ===========================================================
CREATE TABLE table_metadata (
    table_name TEXT PRIMARY KEY,
    domain TEXT NOT NULL,
    description TEXT NOT NULL,
    related_tables TEXT
);

INSERT INTO table_metadata (table_name, domain, description, related_tables) VALUES
('customers', 'E-Commerce', 'Stores customer information: name, city, country', 'orders, payments'),
('products', 'E-Commerce', 'List of products available for sale, including price and ID.', 'order_items, shipments, inventory'),
('orders', 'E-Commerce', 'Customer purchase orders containing order date and customer ID.', 'order_items, payments'),
('order_items', 'E-Commerce', 'Line items for each order linking orders to specific products.', 'orders, products'),
('payments', 'E-Commerce', 'Tracks payments made for orders.', 'orders'),

('employees', 'HR / Travel', 'Company employees with department and role.', 'travel_records, expenses, enrollments, performance_reviews'),
('travel_records', 'HR / Travel', 'Employee travel details such as destination, purpose, and cost.', 'employees, expenses'),
('expenses', 'HR / Travel', 'Expense records per employee with date and description.', 'employees, travel_records'),

('departments', 'Operations', 'Departments within the organization and their locations.', 'employees, assets'),
('assets', 'Operations', 'Company-owned equipment or property assigned to departments.', 'maintenance, departments'),
('maintenance', 'Operations', 'Records maintenance schedules for assets.', 'assets'),

('courses', 'Learning / Performance', 'Training courses available to employees.', 'enrollments'),
('enrollments', 'Learning / Performance', 'Tracks employee participation in courses.', 'employees, courses'),
('performance_reviews', 'Learning / Performance', 'Performance review records for employees.', 'employees'),

('vendors', 'Supply Chain', 'Vendors providing products or materials.', 'shipments, inventory'),
('shipments', 'Supply Chain', 'Shipments of products from vendors.', 'vendors, products'),
('inventory', 'Supply Chain', 'Current stock levels for each product.', 'products, shipments');

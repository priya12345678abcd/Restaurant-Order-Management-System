CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    city VARCHAR(50) NOT NULL,
    area VARCHAR(60) NOT NULL,
    signup_date DATE NOT NULL,
    loyalty_points INT DEFAULT 0,
    customer_status ENUM('Active','Inactive') DEFAULT 'Active');
select*from customers;

CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY,
    restaurant_name VARCHAR(100) NOT NULL,
    cuisine VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    area VARCHAR(60) NOT NULL,
    rating DECIMAL(2,1) NOT NULL,
    delivery_fee DECIMAL(8,2) NOT NULL,
    restaurant_status ENUM('Open','Closed') DEFAULT 'Open');
select*from restaurants;

CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(60) NOT NULL UNIQUE,
    description VARCHAR(200));
select*from categories;

CREATE TABLE menu_items (
    item_id INT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    category_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(8,2) NOT NULL,
    is_veg BOOLEAN NOT NULL,
    preparation_time_min INT NOT NULL,
    item_status ENUM('Available','Unavailable') DEFAULT 'Available',
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id));
select*from menu_items;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    order_date DATETIME NOT NULL,
    order_status ENUM('Delivered','Cancelled','Preparing','Out for Delivery') NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    delivery_fee DECIMAL(8,2) NOT NULL,
    discount DECIMAL(8,2) NOT NULL,
    tax DECIMAL(8,2) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    delivery_address VARCHAR(200) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id));
select*from orders;

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(8,2) NOT NULL,
    item_total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (item_id) REFERENCES menu_items(item_id));
select*from order_items;

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    payment_date DATETIME NOT NULL,
    payment_method ENUM('UPI','Credit Card','Debit Card','Cash','Wallet') NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_status ENUM('Paid','Pending','Refunded') NOT NULL,
    transaction_reference VARCHAR(50) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id));
select*from payments;

CREATE TABLE delivery_partners (
    partner_id INT PRIMARY KEY,
    partner_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    vehicle_type ENUM('Bike','Scooter','Cycle','Car') NOT NULL,
    city VARCHAR(50) NOT NULL,
    partner_status ENUM('Available','Busy','Inactive') NOT NULL,
    join_date DATE NOT NULL);
select*from delivery_partners;

CREATE TABLE deliveries (
    delivery_id INT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    partner_id INT NOT NULL,
    assigned_at DATETIME NOT NULL,
    picked_up_at DATETIME,
    delivered_at DATETIME,
    delivery_status ENUM('Delivered','Out for Delivery','Assigned','Failed') NOT NULL,
    delivery_distance_km DECIMAL(5,2) NOT NULL,
    delivery_time_min INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (partner_id) REFERENCES delivery_partners(partner_id));
select*from deliveries;

CREATE TABLE reviews (
    review_id INT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_text VARCHAR(250),
    review_date DATE NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id));
select*from reviews;
#constrains
CREATE TABLE coupons (
    coupon_id INT PRIMARY KEY,
    coupon_code VARCHAR(30) NOT NULL UNIQUE,
    discount_type ENUM('Percentage','Flat') NOT NULL,
    discount_value DECIMAL(8,2) NOT NULL,
    minimum_order_value DECIMAL(8,2) NOT NULL,
    max_discount DECIMAL(8,2),
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL,
    coupon_status ENUM('Active','Expired') NOT NULL);
select*from coupons;

CREATE TABLE coupon_usage (
    usage_id INT PRIMARY KEY,
    coupon_id INT NOT NULL,
    order_id INT NOT NULL UNIQUE,
    customer_id INT NOT NULL,
    discount_amount DECIMAL(8,2) NOT NULL,
    used_at DATETIME NOT NULL,
    FOREIGN KEY (coupon_id) REFERENCES coupons(coupon_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id));
select*from coupon_usage;

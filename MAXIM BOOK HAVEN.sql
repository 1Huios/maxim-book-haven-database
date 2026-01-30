CREATE DATABASE maxim_book_haven;
USE maxim_book_haven;


CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password_hash VARCHAR(255),
    membership_type ENUM('regular', 'premium', 'admin'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    Description TEXT,
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT NOT NULL,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL,
    category VARCHAR(50),
    image_url VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_price CHECK (price >= 0),
    CONSTRAINT chk_stock_quantity CHECK (stock_quantity >= 0)
);


CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    biography TEXT,
    birth_year INT,
    nationality VARCHAR(50)
);


CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    author_id INT,
    genre VARCHAR(50),
    isbn VARCHAR(20) UNIQUE,
    publication_year INT,
    price DECIMAL(10,2),
    stock_quantity INT,
    availability ENUM('in stock', 'out of stock', 'digital') DEFAULT 'in stock',
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);


CREATE TABLE bookshelves (
    shelf_id INT AUTO_INCREMENT PRIMARY KEY,
    shelf_name VARCHAR(100),
    location VARCHAR(100),
    capacity INT
);


CREATE TABLE elibrary (
    elibrary_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    file_url VARCHAR(255),
    access_level ENUM('free', 'paid'),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);


CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2),
    delivery_required BOOLEAN DEFAULT FALSE,
    delivery_status ENUM('pending', 'shipped', 'delivered') DEFAULT 'pending',
    estimated_delivery_time INT COMMENT 'Estimated delivery time in hours',
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


CREATE TABLE order_details (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    book_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);


CREATE TABLE book_reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    book_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);


CREATE TABLE borrowing_history (
    borrow_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    book_id INT,
    borrow_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    return_date TIMESTAMP NULL,
    status ENUM('borrowed', 'returned') DEFAULT 'borrowed',
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);


CREATE TABLE penalties (
    penalty_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    borrow_id INT,
    fine_amount DECIMAL(10,2),
    reason TEXT,
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (borrow_id) REFERENCES borrowing_history(borrow_id)
);


CREATE TABLE wishlist (
    wishlist_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    book_id INT,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);


CREATE TABLE book_reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    book_id INT,
    reservation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'confirmed', 'cancelled') DEFAULT 'pending',
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);


CREATE TABLE delivery_drivers (
    driver_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    phone VARCHAR(20),
    vehicle_type VARCHAR(50),
    license_number VARCHAR(50) UNIQUE,
    hire_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE deliveries (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    driver_id INT,
    delivery_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'in transit', 'delivered') DEFAULT 'pending',
    real_time_location VARCHAR(255) COMMENT 'Live tracking URL or coordinates',
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (driver_id) REFERENCES delivery_drivers(driver_id)
);


CREATE TABLE delivery_feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    order_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    feedback_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);


CREATE TABLE discounts (
    discount_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    discount_percentage DECIMAL(5,2),
    valid_from DATE,
    valid_until DATE,
    reason TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


CREATE TABLE loyalty_rewards (
    reward_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    points INT DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


CREATE TABLE subscriptions (
    subscription_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    plan ENUM('basic', 'premium', 'elite'),
    start_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_date TIMESTAMP NULL,
    status ENUM('active', 'expired', 'cancelled') DEFAULT 'active',
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


CREATE TABLE gift_cards (
    card_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    card_code VARCHAR(50) UNIQUE,
    balance DECIMAL(10,2),
    expiration_date DATE,
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


CREATE TABLE referral_bonuses (
    bonus_id INT AUTO_INCREMENT PRIMARY KEY,
    referrer_id INT,
    referred_user_id INT,
    bonus_amount DECIMAL(10,2),
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (referrer_id) REFERENCES users(user_id),
    FOREIGN KEY (referred_user_id) REFERENCES users(user_id)
);
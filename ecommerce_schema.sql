-- Ecommerce Database Setup for RUX
-- Database: PostgreSQL (Chosen over MySQL for better JSON support, advanced indexing, and scalability in complex ecommerce systems)
-- PostgreSQL provides superior handling of complex queries, transactions, and is more suitable for high-traffic sites.

-- Create database
CREATE DATABASE rux_ecommerce;

-- Connect to the database
\c rux_ecommerce;

-- Create tables with proper relationships

-- Users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories table
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL
);

-- Products table
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    category_id INTEGER REFERENCES categories(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders table
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Order items table
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0)
);

-- Cart table
CREATE TABLE cart (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL CHECK (quantity > 0)
);

-- Indexes for performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_cart_user_id ON cart(user_id);
CREATE INDEX idx_cart_product_id ON cart(product_id);

-- Sample data inserts
INSERT INTO categories (name) VALUES
('Tops'),
('Bottoms'),
('Outerwear'),
('Accessories');

INSERT INTO users (name, email, password_hash, role) VALUES
('Ada Okonkwo', 'ada@example.com', '$2b$10$example.hash.here', 'customer'),
('Admin User', 'admin@rux.com', '$2b$10$admin.hash.here', 'admin');

INSERT INTO products (name, description, price, stock, category_id) VALUES
('Void Overcoat', 'Double-faced wool, raw hem detail, architectural cut.', 185000.00, 10, 3),
('Drift Wide Trouser', 'Japanese selvedge denim, dropped crotch, raw cuff.', 72000.00, 20, 2),
('Haze Boxy Shirt', 'Crinkled cotton poplin, extended hem, single chest pocket.', 54000.00, 15, 1),
('Signal Bucket Hat', '6-panel nylon, tonal embroidery, structured brim.', 28000.00, 25, 4);

INSERT INTO cart (user_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 2, 2);

-- Example order creation (would be done in application logic)
-- First, create an order
INSERT INTO orders (user_id, total_amount, status) VALUES
(1, 257000.00, 'pending');

-- Then, add order items
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 185000.00),
(1, 2, 1, 72000.00);
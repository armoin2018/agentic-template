# Database Development & Management Instructions

## Tool Overview

- **Tool Name**: Database Management Systems
- **Version**: MySQL 8.0+, PostgreSQL 15+, SQLite 3.40+, MongoDB 7.0+
- **Category**: Database & Data Management
- **Purpose**: Comprehensive database design, development, and administration
- **Prerequisites**: Database server installation, appropriate client tools, backup systems

## Installation & Setup

### MySQL Installation

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install mysql-server mysql-client

# CentOS/RHEL
sudo yum install mysql-server mysql

# macOS (Homebrew)
brew install mysql

# Start MySQL service
sudo systemctl start mysql
sudo systemctl enable mysql

# Secure installation
sudo mysql_secure_installation

# Connect to MySQL
mysql -u root -p
```

### PostgreSQL Installation

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install postgresql postgresql-contrib

# CentOS/RHEL
sudo yum install postgresql-server postgresql-contrib
sudo postgresql-setup initdb

# macOS (Homebrew)
brew install postgresql

# Start PostgreSQL service
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Connect to PostgreSQL
sudo -u postgres psql
```

### Database Configuration

```sql
-- MySQL Configuration (my.cnf)
[mysqld]
# Basic settings
port = 3306
socket = /var/run/mysqld/mysqld.sock
datadir = /var/lib/mysql
log-error = /var/log/mysql/error.log

# Character set and collation
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

# Performance tuning
innodb_buffer_pool_size = 1G
innodb_log_file_size = 256M
innodb_flush_log_at_trx_commit = 2
innodb_flush_method = O_DIRECT

# Connection settings
max_connections = 200
connect_timeout = 10
wait_timeout = 600
interactive_timeout = 600

# Query cache (deprecated in MySQL 8.0)
# query_cache_type = 1
# query_cache_size = 64M

# Binary logging
log-bin = mysql-bin
binlog_format = ROW
expire_logs_days = 7

# Slow query log
slow_query_log = 1
slow_query_log_file = /var/log/mysql/slow.log
long_query_time = 2

# General query log (disable in production)
# general_log = 1
# general_log_file = /var/log/mysql/general.log
```

```postgresql
-- PostgreSQL Configuration (postgresql.conf)
# Memory settings
shared_buffers = 256MB
work_mem = 4MB
maintenance_work_mem = 64MB
effective_cache_size = 1GB

# Checkpoint settings
checkpoint_completion_target = 0.7
wal_buffers = 16MB
default_statistics_target = 100

# Connection settings
max_connections = 100
listen_addresses = 'localhost'
port = 5432

# Logging
log_destination = 'stderr'
logging_collector = on
log_directory = 'pg_log'
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
log_min_duration_statement = 1000
log_line_prefix = '%t [%p]: [%l-1] user=%u,db=%d,app=%a,client=%h '
log_checkpoints = on
log_connections = on
log_disconnections = on
log_lock_waits = on

# Security
ssl = on
password_encryption = scram-sha-256
```

## Database Design Patterns

### Normalized Database Design

```sql
-- Example: E-commerce Database Schema

-- Users table (1NF, 2NF, 3NF compliant)
CREATE TABLE users (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    email_verified_at TIMESTAMP NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NULL,
    date_of_birth DATE NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,

    PRIMARY KEY (id),
    INDEX idx_users_email (email),
    INDEX idx_users_username (username),
    INDEX idx_users_created_at (created_at),
    INDEX idx_users_deleted_at (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- User addresses (separate table for normalization)
CREATE TABLE user_addresses (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id BIGINT UNSIGNED NOT NULL,
    type ENUM('billing', 'shipping', 'both') DEFAULT 'both',
    is_default BOOLEAN DEFAULT FALSE,
    address_line_1 VARCHAR(255) NOT NULL,
    address_line_2 VARCHAR(255) NULL,
    city VARCHAR(100) NOT NULL,
    state_province VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country_code CHAR(2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_addresses_user_id (user_id),
    INDEX idx_user_addresses_type (type),
    INDEX idx_user_addresses_default (is_default)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Categories table (hierarchical structure)
CREATE TABLE categories (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    parent_id BIGINT UNSIGNED NULL,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    description TEXT NULL,
    image_url VARCHAR(500) NULL,
    sort_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL,
    INDEX idx_categories_parent_id (parent_id),
    INDEX idx_categories_slug (slug),
    INDEX idx_categories_active (is_active),
    INDEX idx_categories_sort_order (sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Products table
CREATE TABLE products (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    sku VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    description TEXT NULL,
    short_description VARCHAR(500) NULL,
    price DECIMAL(10,2) NOT NULL,
    compare_price DECIMAL(10,2) NULL,
    cost_price DECIMAL(10,2) NULL,
    weight DECIMAL(8,2) NULL,
    dimensions_length DECIMAL(8,2) NULL,
    dimensions_width DECIMAL(8,2) NULL,
    dimensions_height DECIMAL(8,2) NULL,
    stock_quantity INT DEFAULT 0,
    stock_status ENUM('in_stock', 'out_of_stock', 'on_backorder') DEFAULT 'in_stock',
    manage_stock BOOLEAN DEFAULT TRUE,
    featured_image_url VARCHAR(500) NULL,
    gallery JSON NULL,
    seo_title VARCHAR(255) NULL,
    seo_description VARCHAR(500) NULL,
    is_active BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,
    is_digital BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    UNIQUE INDEX idx_products_sku (sku),
    INDEX idx_products_slug (slug),
    INDEX idx_products_price (price),
    INDEX idx_products_stock_status (stock_status),
    INDEX idx_products_active (is_active),
    INDEX idx_products_featured (is_featured),
    INDEX idx_products_created_at (created_at),
    FULLTEXT INDEX ft_products_search (name, description, short_description)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Product categories junction table (many-to-many)
CREATE TABLE product_categories (
    product_id BIGINT UNSIGNED NOT NULL,
    category_id BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    INDEX idx_product_categories_product_id (product_id),
    INDEX idx_product_categories_category_id (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Product attributes (EAV pattern for flexible attributes)
CREATE TABLE product_attributes (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    type ENUM('text', 'number', 'boolean', 'date', 'select', 'multiselect') DEFAULT 'text',
    is_required BOOLEAN DEFAULT FALSE,
    is_filterable BOOLEAN DEFAULT FALSE,
    sort_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    INDEX idx_product_attributes_name (name),
    INDEX idx_product_attributes_type (type),
    INDEX idx_product_attributes_filterable (is_filterable)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE product_attribute_values (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    product_id BIGINT UNSIGNED NOT NULL,
    attribute_id BIGINT UNSIGNED NOT NULL,
    value TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (attribute_id) REFERENCES product_attributes(id) ON DELETE CASCADE,
    UNIQUE INDEX idx_product_attribute_values_unique (product_id, attribute_id),
    INDEX idx_product_attribute_values_product_id (product_id),
    INDEX idx_product_attribute_values_attribute_id (attribute_id),
    INDEX idx_product_attribute_values_value (value(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Orders table
CREATE TABLE orders (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_number VARCHAR(50) NOT NULL UNIQUE,
    user_id BIGINT UNSIGNED NULL,
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled', 'refunded') DEFAULT 'pending',
    currency CHAR(3) DEFAULT 'USD',
    subtotal DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    tax_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    shipping_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    discount_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    total_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,

    -- Billing information
    billing_first_name VARCHAR(100) NOT NULL,
    billing_last_name VARCHAR(100) NOT NULL,
    billing_email VARCHAR(255) NOT NULL,
    billing_phone VARCHAR(20) NULL,
    billing_address_line_1 VARCHAR(255) NOT NULL,
    billing_address_line_2 VARCHAR(255) NULL,
    billing_city VARCHAR(100) NOT NULL,
    billing_state_province VARCHAR(100) NOT NULL,
    billing_postal_code VARCHAR(20) NOT NULL,
    billing_country_code CHAR(2) NOT NULL,

    -- Shipping information
    shipping_first_name VARCHAR(100) NOT NULL,
    shipping_last_name VARCHAR(100) NOT NULL,
    shipping_address_line_1 VARCHAR(255) NOT NULL,
    shipping_address_line_2 VARCHAR(255) NULL,
    shipping_city VARCHAR(100) NOT NULL,
    shipping_state_province VARCHAR(100) NOT NULL,
    shipping_postal_code VARCHAR(20) NOT NULL,
    shipping_country_code CHAR(2) NOT NULL,

    notes TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    UNIQUE INDEX idx_orders_order_number (order_number),
    INDEX idx_orders_user_id (user_id),
    INDEX idx_orders_status (status),
    INDEX idx_orders_total_amount (total_amount),
    INDEX idx_orders_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Order items table
CREATE TABLE order_items (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    product_sku VARCHAR(100) NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(12,2) NOT NULL,
    product_data JSON NULL, -- Store product snapshot
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT,
    INDEX idx_order_items_order_id (order_id),
    INDEX idx_order_items_product_id (product_id),
    INDEX idx_order_items_sku (product_sku)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### PostgreSQL Implementation

```postgresql
-- PostgreSQL version with advanced features

-- Users table with PostgreSQL-specific features
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    email_verified_at TIMESTAMPTZ,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    preferences JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

-- Create indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_created_at ON users(created_at);
CREATE INDEX idx_users_deleted_at ON users(deleted_at) WHERE deleted_at IS NOT NULL;
CREATE INDEX idx_users_preferences ON users USING GIN(preferences);

-- Full-text search index
CREATE INDEX idx_users_search ON users USING GIN(
    to_tsvector('english', first_name || ' ' || last_name || ' ' || email)
);

-- Products table with advanced PostgreSQL features
CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    sku VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    short_description VARCHAR(500),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    compare_price DECIMAL(10,2) CHECK (compare_price >= 0),
    cost_price DECIMAL(10,2) CHECK (cost_price >= 0),
    weight DECIMAL(8,2) CHECK (weight >= 0),
    dimensions JSONB, -- Store as JSON: {"length": 10, "width": 5, "height": 3}
    stock_quantity INTEGER DEFAULT 0 CHECK (stock_quantity >= 0),
    stock_status VARCHAR(20) DEFAULT 'in_stock' CHECK (stock_status IN ('in_stock', 'out_of_stock', 'on_backorder')),
    manage_stock BOOLEAN DEFAULT TRUE,
    images JSONB DEFAULT '[]', -- Array of image URLs
    metadata JSONB DEFAULT '{}', -- Flexible metadata storage
    tags TEXT[], -- PostgreSQL array type
    is_active BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,
    is_digital BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for products
CREATE INDEX idx_products_sku ON products(sku);
CREATE INDEX idx_products_slug ON products(slug);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_stock_status ON products(stock_status);
CREATE INDEX idx_products_active ON products(is_active);
CREATE INDEX idx_products_featured ON products(is_featured);
CREATE INDEX idx_products_tags ON products USING GIN(tags);
CREATE INDEX idx_products_metadata ON products USING GIN(metadata);

-- Full-text search for products
CREATE INDEX idx_products_search ON products USING GIN(
    to_tsvector('english', name || ' ' || COALESCE(description, '') || ' ' || COALESCE(short_description, ''))
);

-- Trigger for updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Partitioned orders table (by date)
CREATE TABLE orders (
    id BIGSERIAL,
    order_number VARCHAR(50) NOT NULL,
    user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled', 'refunded')),
    currency CHAR(3) DEFAULT 'USD',
    subtotal DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    tax_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    shipping_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    discount_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    total_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    billing_address JSONB NOT NULL,
    shipping_address JSONB NOT NULL,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    PRIMARY KEY (id, created_at)
) PARTITION BY RANGE (created_at);

-- Create monthly partitions
CREATE TABLE orders_2024_01 PARTITION OF orders
    FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE TABLE orders_2024_02 PARTITION OF orders
    FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');

-- Function to create future partitions automatically
CREATE OR REPLACE FUNCTION create_monthly_partition(table_name TEXT, start_date DATE)
RETURNS VOID AS $$
DECLARE
    partition_name TEXT;
    end_date DATE;
BEGIN
    partition_name := table_name || '_' || to_char(start_date, 'YYYY_MM');
    end_date := start_date + INTERVAL '1 month';

    EXECUTE format('CREATE TABLE %I PARTITION OF %I FOR VALUES FROM (%L) TO (%L)',
                   partition_name, table_name, start_date, end_date);
END;
$$ LANGUAGE plpgsql;
```

## Query Optimization Strategies

### Index Optimization

```sql
-- Analyze query performance
EXPLAIN ANALYZE SELECT * FROM products WHERE price BETWEEN 10.00 AND 50.00;

-- Create composite indexes for common query patterns
CREATE INDEX idx_products_price_active ON products(price, is_active);
CREATE INDEX idx_products_category_price ON product_categories(category_id, product_id);

-- Covering indexes (include additional columns)
CREATE INDEX idx_orders_user_status_covering
ON orders(user_id, status)
INCLUDE (total_amount, created_at);

-- Partial indexes for specific conditions
CREATE INDEX idx_products_active_featured
ON products(price)
WHERE is_active = TRUE AND is_featured = TRUE;

-- Function-based indexes
CREATE INDEX idx_users_lower_email ON users(LOWER(email));
CREATE INDEX idx_products_monthly_sales
ON order_items(product_id, EXTRACT(YEAR_MONTH FROM created_at));

-- JSON indexes (PostgreSQL)
CREATE INDEX idx_products_metadata_color
ON products USING GIN ((metadata->>'color'));

CREATE INDEX idx_products_tags_gin
ON products USING GIN (tags);
```

### Query Optimization Examples

```sql
-- Optimized pagination with cursor-based approach
SELECT p.*, pc.category_id
FROM products p
LEFT JOIN product_categories pc ON p.id = pc.product_id
WHERE p.id > :last_id  -- cursor-based pagination
  AND p.is_active = TRUE
ORDER BY p.id
LIMIT 20;

-- Optimized aggregation queries
SELECT
    c.name AS category_name,
    COUNT(DISTINCT p.id) AS product_count,
    AVG(p.price) AS avg_price,
    MIN(p.price) AS min_price,
    MAX(p.price) AS max_price
FROM categories c
LEFT JOIN product_categories pc ON c.id = pc.category_id
LEFT JOIN products p ON pc.product_id = p.id AND p.is_active = TRUE
WHERE c.is_active = TRUE
GROUP BY c.id, c.name
HAVING COUNT(DISTINCT p.id) > 0
ORDER BY product_count DESC;

-- Complex search with scoring
SELECT
    p.*,
    MATCH(p.name, p.description) AGAINST (:search_term IN NATURAL LANGUAGE MODE) AS relevance_score
FROM products p
WHERE MATCH(p.name, p.description) AGAINST (:search_term IN NATURAL LANGUAGE MODE)
  AND p.is_active = TRUE
  AND p.price BETWEEN :min_price AND :max_price
ORDER BY relevance_score DESC, p.created_at DESC
LIMIT 50;

-- PostgreSQL full-text search
SELECT
    p.*,
    ts_rank(to_tsvector('english', p.name || ' ' || COALESCE(p.description, '')),
            plainto_tsquery('english', :search_term)) AS rank
FROM products p
WHERE to_tsvector('english', p.name || ' ' || COALESCE(p.description, ''))
      @@ plainto_tsquery('english', :search_term)
  AND p.is_active = TRUE
ORDER BY rank DESC, p.created_at DESC
LIMIT 50;

-- Efficient hierarchical queries (categories)
WITH RECURSIVE category_tree AS (
    -- Anchor: root categories
    SELECT id, parent_id, name, 0 as level, ARRAY[id] as path
    FROM categories
    WHERE parent_id IS NULL

    UNION ALL

    -- Recursive: child categories
    SELECT c.id, c.parent_id, c.name, ct.level + 1, ct.path || c.id
    FROM categories c
    INNER JOIN category_tree ct ON c.parent_id = ct.id
    WHERE ct.level < 10 -- Prevent infinite recursion
)
SELECT * FROM category_tree ORDER BY path;

-- Window functions for analytics
SELECT
    o.id,
    o.total_amount,
    o.created_at,
    ROW_NUMBER() OVER (PARTITION BY o.user_id ORDER BY o.created_at) AS order_sequence,
    LAG(o.total_amount) OVER (PARTITION BY o.user_id ORDER BY o.created_at) AS prev_order_amount,
    LEAD(o.created_at) OVER (PARTITION BY o.user_id ORDER BY o.created_at) AS next_order_date,
    SUM(o.total_amount) OVER (PARTITION BY o.user_id ORDER BY o.created_at ROWS UNBOUNDED PRECEDING) AS running_total
FROM orders o
WHERE o.status IN ('delivered', 'shipped')
ORDER BY o.user_id, o.created_at;
```

## Advanced Database Features

### Stored Procedures and Functions

```sql
-- MySQL Stored Procedure
DELIMITER //

CREATE PROCEDURE GetUserOrderSummary(
    IN user_id_param BIGINT UNSIGNED,
    IN start_date DATE,
    IN end_date DATE
)
BEGIN
    DECLARE total_orders INT DEFAULT 0;
    DECLARE total_amount DECIMAL(12,2) DEFAULT 0.00;
    DECLARE avg_order_value DECIMAL(12,2) DEFAULT 0.00;

    -- Get order statistics
    SELECT
        COUNT(*),
        COALESCE(SUM(total_amount), 0),
        COALESCE(AVG(total_amount), 0)
    INTO total_orders, total_amount, avg_order_value
    FROM orders
    WHERE user_id = user_id_param
      AND DATE(created_at) BETWEEN start_date AND end_date
      AND status IN ('delivered', 'shipped');

    -- Return results
    SELECT
        user_id_param AS user_id,
        total_orders,
        total_amount,
        avg_order_value,
        start_date,
        end_date;

    -- Also return top products
    SELECT
        p.name,
        SUM(oi.quantity) AS total_quantity,
        SUM(oi.total_price) AS total_spent
    FROM orders o
    JOIN order_items oi ON o.id = oi.order_id
    JOIN products p ON oi.product_id = p.id
    WHERE o.user_id = user_id_param
      AND DATE(o.created_at) BETWEEN start_date AND end_date
      AND o.status IN ('delivered', 'shipped')
    GROUP BY p.id, p.name
    ORDER BY total_spent DESC
    LIMIT 10;
END //

DELIMITER ;

-- Call the procedure
CALL GetUserOrderSummary(123, '2024-01-01', '2024-12-31');
```

```postgresql
-- PostgreSQL Function
CREATE OR REPLACE FUNCTION get_product_analytics(
    category_id_param BIGINT DEFAULT NULL,
    start_date DATE DEFAULT CURRENT_DATE - INTERVAL '30 days',
    end_date DATE DEFAULT CURRENT_DATE
)
RETURNS TABLE (
    product_id BIGINT,
    product_name VARCHAR(255),
    total_sales BIGINT,
    total_revenue DECIMAL(12,2),
    avg_rating DECIMAL(3,2),
    stock_level INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id,
        p.name,
        COALESCE(SUM(oi.quantity), 0)::BIGINT AS total_sales,
        COALESCE(SUM(oi.total_price), 0) AS total_revenue,
        COALESCE(AVG(pr.rating), 0)::DECIMAL(3,2) AS avg_rating,
        p.stock_quantity
    FROM products p
    LEFT JOIN product_categories pc ON p.id = pc.product_id
    LEFT JOIN order_items oi ON p.id = oi.product_id
    LEFT JOIN orders o ON oi.order_id = o.id
        AND o.created_at BETWEEN start_date AND end_date
        AND o.status IN ('delivered', 'shipped')
    LEFT JOIN product_reviews pr ON p.id = pr.product_id
    WHERE (category_id_param IS NULL OR pc.category_id = category_id_param)
      AND p.is_active = TRUE
    GROUP BY p.id, p.name, p.stock_quantity
    ORDER BY total_revenue DESC;
END;
$$ LANGUAGE plpgsql;

-- Call the function
SELECT * FROM get_product_analytics(5, '2024-01-01', '2024-12-31');
```

### Triggers and Business Logic

```sql
-- MySQL Triggers
DELIMITER //

-- Trigger to update product stock after order
CREATE TRIGGER update_product_stock_after_order
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE products
    SET stock_quantity = stock_quantity - NEW.quantity,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = NEW.product_id;

    -- Update stock status based on quantity
    UPDATE products
    SET stock_status = CASE
        WHEN stock_quantity <= 0 THEN 'out_of_stock'
        WHEN stock_quantity <= 10 THEN 'low_stock'
        ELSE 'in_stock'
    END
    WHERE id = NEW.product_id;
END //

-- Trigger to log price changes
CREATE TRIGGER log_product_price_changes
BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
    IF OLD.price != NEW.price THEN
        INSERT INTO product_price_history (
            product_id,
            old_price,
            new_price,
            changed_by,
            changed_at
        ) VALUES (
            NEW.id,
            OLD.price,
            NEW.price,
            USER(),
            NOW()
        );
    END IF;
END //

-- Trigger to calculate order totals
CREATE TRIGGER calculate_order_total
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE orders
    SET subtotal = (
        SELECT COALESCE(SUM(total_price), 0)
        FROM order_items
        WHERE order_id = NEW.order_id
    ),
    total_amount = subtotal + tax_amount + shipping_amount - discount_amount
    WHERE id = NEW.order_id;
END //

DELIMITER ;
```

```postgresql
-- PostgreSQL Triggers
CREATE OR REPLACE FUNCTION update_product_stock_trigger()
RETURNS TRIGGER AS $$
BEGIN
    -- Update stock quantity
    UPDATE products
    SET stock_quantity = stock_quantity - NEW.quantity,
        updated_at = NOW()
    WHERE id = NEW.product_id;

    -- Update stock status
    UPDATE products
    SET stock_status = CASE
        WHEN stock_quantity <= 0 THEN 'out_of_stock'
        WHEN stock_quantity <= 10 THEN 'low_stock'
        ELSE 'in_stock'
    END
    WHERE id = NEW.product_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_product_stock_after_order
    AFTER INSERT ON order_items
    FOR EACH ROW
    EXECUTE FUNCTION update_product_stock_trigger();

-- Audit trigger
CREATE OR REPLACE FUNCTION audit_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit_log (table_name, operation, new_data, user_name, timestamp)
        VALUES (TG_TABLE_NAME, TG_OP, row_to_json(NEW), current_user, NOW());
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_log (table_name, operation, old_data, new_data, user_name, timestamp)
        VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD), row_to_json(NEW), current_user, NOW());
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit_log (table_name, operation, old_data, user_name, timestamp)
        VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD), current_user, NOW());
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Apply audit trigger to important tables
CREATE TRIGGER audit_users_trigger
    AFTER INSERT OR UPDATE OR DELETE ON users
    FOR EACH ROW EXECUTE FUNCTION audit_trigger();

CREATE TRIGGER audit_orders_trigger
    AFTER INSERT OR UPDATE OR DELETE ON orders
    FOR EACH ROW EXECUTE FUNCTION audit_trigger();
```

## Database Security

### User Management and Permissions

```sql
-- MySQL User Management
-- Create dedicated application user
CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'strong_password_here';
CREATE USER 'app_readonly'@'localhost' IDENTIFIED BY 'readonly_password';

-- Grant specific permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON ecommerce.* TO 'app_user'@'localhost';
GRANT SELECT ON ecommerce.* TO 'app_readonly'@'localhost';

-- Create role-based permissions
CREATE ROLE 'ecommerce_admin';
CREATE ROLE 'ecommerce_user';
CREATE ROLE 'ecommerce_readonly';

GRANT ALL PRIVILEGES ON ecommerce.* TO 'ecommerce_admin';
GRANT SELECT, INSERT, UPDATE, DELETE ON ecommerce.products TO 'ecommerce_user';
GRANT SELECT, INSERT, UPDATE, DELETE ON ecommerce.orders TO 'ecommerce_user';
GRANT SELECT ON ecommerce.* TO 'ecommerce_readonly';

-- Assign roles to users
GRANT 'ecommerce_user' TO 'app_user'@'localhost';
GRANT 'ecommerce_readonly' TO 'app_readonly'@'localhost';

-- Set default roles
SET DEFAULT ROLE ALL TO 'app_user'@'localhost';
```

```postgresql
-- PostgreSQL User Management
-- Create roles
CREATE ROLE ecommerce_admin;
CREATE ROLE ecommerce_user;
CREATE ROLE ecommerce_readonly;

-- Grant permissions to roles
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ecommerce_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO ecommerce_admin;

GRANT SELECT, INSERT, UPDATE, DELETE ON products, categories, orders, order_items TO ecommerce_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO ecommerce_user;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO ecommerce_readonly;

-- Create users and assign roles
CREATE USER app_user WITH PASSWORD 'strong_password_here';
CREATE USER app_readonly WITH PASSWORD 'readonly_password';

GRANT ecommerce_user TO app_user;
GRANT ecommerce_readonly TO app_readonly;

-- Set default privileges for future objects
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO ecommerce_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO ecommerce_readonly;
```

### Data Encryption and Security

```sql
-- MySQL data encryption
-- Enable transparent data encryption (TDE)
-- Add to my.cnf:
-- early-plugin-load = keyring_file.so
-- keyring_file_data = /var/lib/mysql-keyring/keyring

-- Create encrypted table
CREATE TABLE sensitive_data (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id BIGINT UNSIGNED NOT NULL,
    credit_card_token VARCHAR(255) NOT NULL,
    encrypted_ssn VARBINARY(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENCRYPTION='Y';

-- Application-level encryption functions
DELIMITER //

CREATE FUNCTION encrypt_sensitive_data(plaintext TEXT, encryption_key VARCHAR(255))
RETURNS VARBINARY(255)
READS SQL DATA
DETERMINISTIC
BEGIN
    RETURN AES_ENCRYPT(plaintext, encryption_key);
END //

CREATE FUNCTION decrypt_sensitive_data(ciphertext VARBINARY(255), encryption_key VARCHAR(255))
RETURNS TEXT
READS SQL DATA
DETERMINISTIC
BEGIN
    RETURN CAST(AES_DECRYPT(ciphertext, encryption_key) AS CHAR);
END //

DELIMITER ;

-- Example usage
INSERT INTO sensitive_data (user_id, credit_card_token, encrypted_ssn)
VALUES (123, 'tok_1234567890', encrypt_sensitive_data('123-45-6789', 'encryption_key_here'));
```

```postgresql
-- PostgreSQL encryption
-- Install pgcrypto extension
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Create table with encrypted columns
CREATE TABLE sensitive_data (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id),
    credit_card_token VARCHAR(255) NOT NULL,
    encrypted_ssn BYTEA NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insert encrypted data
INSERT INTO sensitive_data (user_id, credit_card_token, encrypted_ssn)
VALUES (123, 'tok_1234567890', pgp_sym_encrypt('123-45-6789', 'encryption_key_here'));

-- Query encrypted data
SELECT
    id,
    user_id,
    credit_card_token,
    pgp_sym_decrypt(encrypted_ssn, 'encryption_key_here') AS ssn
FROM sensitive_data
WHERE user_id = 123;

-- Row-level security (RLS)
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Create policy for users to see only their own orders
CREATE POLICY user_orders_policy ON orders
    FOR ALL TO ecommerce_user
    USING (user_id = current_setting('app.current_user_id')::BIGINT);

-- Create policy for admins to see all orders
CREATE POLICY admin_orders_policy ON orders
    FOR ALL TO ecommerce_admin
    USING (true);
```

## Database Monitoring and Maintenance

### Performance Monitoring

```sql
-- MySQL Performance Monitoring Queries

-- Show slow queries
SELECT
    query_time,
    lock_time,
    rows_sent,
    rows_examined,
    sql_text
FROM mysql.slow_log
WHERE start_time >= DATE_SUB(NOW(), INTERVAL 1 HOUR)
ORDER BY query_time DESC;

-- Show table sizes
SELECT
    table_schema,
    table_name,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS table_size_mb,
    table_rows
FROM information_schema.tables
WHERE table_schema = 'ecommerce'
ORDER BY table_size_mb DESC;

-- Show index usage
SELECT
    t.table_schema,
    t.table_name,
    s.index_name,
    s.column_name,
    s.seq_in_index,
    s.cardinality,
    ROUND(((s.cardinality / t.table_rows) * 100), 2) AS selectivity
FROM information_schema.statistics s
JOIN information_schema.tables t ON s.table_schema = t.table_schema
    AND s.table_name = t.table_name
WHERE t.table_schema = 'ecommerce'
    AND t.table_rows > 0
ORDER BY t.table_name, s.index_name, s.seq_in_index;

-- Show current connections and processes
SELECT
    id,
    user,
    host,
    db,
    command,
    time,
    state,
    LEFT(info, 100) AS query_start
FROM information_schema.processlist
WHERE command != 'Sleep'
ORDER BY time DESC;
```

```postgresql
-- PostgreSQL Performance Monitoring

-- Show slow queries (requires pg_stat_statements extension)
SELECT
    query,
    calls,
    total_time,
    mean_time,
    rows
FROM pg_stat_statements
ORDER BY total_time DESC
LIMIT 20;

-- Show table sizes
SELECT
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size,
    pg_stat_get_live_tuples(c.oid) AS rows
FROM pg_tables pt
JOIN pg_class c ON c.relname = pt.tablename
JOIN pg_namespace n ON n.oid = c.relnamespace AND n.nspname = pt.schemaname
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- Show index usage
SELECT
    schemaname,
    tablename,
    indexname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;

-- Show current connections
SELECT
    pid,
    usename,
    application_name,
    client_addr,
    state,
    query_start,
    LEFT(query, 100) AS query_start
FROM pg_stat_activity
WHERE state != 'idle'
ORDER BY query_start DESC;

-- Show blocking queries
SELECT
    blocked_locks.pid AS blocked_pid,
    blocked_activity.usename AS blocked_user,
    blocking_locks.pid AS blocking_pid,
    blocking_activity.usename AS blocking_user,
    blocked_activity.query AS blocked_statement,
    blocking_activity.query AS blocking_statement
FROM pg_catalog.pg_locks blocked_locks
JOIN pg_catalog.pg_stat_activity blocked_activity ON blocked_activity.pid = blocked_locks.pid
JOIN pg_catalog.pg_locks blocking_locks ON blocking_locks.locktype = blocked_locks.locktype
    AND blocking_locks.DATABASE IS NOT DISTINCT FROM blocked_locks.DATABASE
    AND blocking_locks.relation IS NOT DISTINCT FROM blocked_locks.relation
    AND blocking_locks.page IS NOT DISTINCT FROM blocked_locks.page
    AND blocking_locks.tuple IS NOT DISTINCT FROM blocked_locks.tuple
    AND blocking_locks.virtualxid IS NOT DISTINCT FROM blocked_locks.virtualxid
    AND blocking_locks.transactionid IS NOT DISTINCT FROM blocked_locks.transactionid
    AND blocking_locks.classid IS NOT DISTINCT FROM blocked_locks.classid
    AND blocking_locks.objid IS NOT DISTINCT FROM blocked_locks.objid
    AND blocking_locks.objsubid IS NOT DISTINCT FROM blocked_locks.objsubid
    AND blocking_locks.pid != blocked_locks.pid
JOIN pg_catalog.pg_stat_activity blocking_activity ON blocking_activity.pid = blocking_locks.pid
WHERE NOT blocked_locks.GRANTED;
```

### Backup and Recovery

```bash
#!/bin/bash
# MySQL Backup Script

DB_NAME="ecommerce"
DB_USER="backup_user"
DB_PASS="backup_password"
BACKUP_DIR="/var/backups/mysql"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${DATE}.sql.gz"

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Create backup with compression
mysqldump --user=$DB_USER --password=$DB_PASS \
    --single-transaction \
    --routines \
    --triggers \
    --events \
    --hex-blob \
    --opt \
    $DB_NAME | gzip > $BACKUP_FILE

# Verify backup was created
if [ -f "$BACKUP_FILE" ]; then
    echo "Backup created successfully: $BACKUP_FILE"

    # Remove backups older than 7 days
    find $BACKUP_DIR -name "${DB_NAME}_*.sql.gz" -mtime +7 -delete

    # Upload to cloud storage (optional)
    # aws s3 cp $BACKUP_FILE s3://my-backups/mysql/
else
    echo "Backup failed!"
    exit 1
fi

# Test backup integrity
gunzip -t $BACKUP_FILE
if [ $? -eq 0 ]; then
    echo "Backup integrity verified"
else
    echo "Backup integrity check failed!"
    exit 1
fi
```

```bash
#!/bin/bash
# PostgreSQL Backup Script

DB_NAME="ecommerce"
DB_USER="postgres"
BACKUP_DIR="/var/backups/postgresql"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${DATE}.sql.gz"

# Create backup directory
mkdir -p $BACKUP_DIR

# Create backup
pg_dump --username=$DB_USER \
    --host=localhost \
    --format=custom \
    --verbose \
    --no-password \
    --clean \
    --create \
    $DB_NAME | gzip > $BACKUP_FILE

# Verify backup
if [ ${PIPESTATUS[0]} -eq 0 ]; then
    echo "Backup created successfully: $BACKUP_FILE"

    # Remove old backups
    find $BACKUP_DIR -name "${DB_NAME}_*.sql.gz" -mtime +7 -delete

    # Create point-in-time recovery archive
    pg_basebackup -D ${BACKUP_DIR}/basebackup_${DATE} -Ft -z -P
else
    echo "Backup failed!"
    exit 1
fi
```

This comprehensive database guide covers everything from basic setup to advanced features like partitioning, stored procedures, security, and monitoring. It provides practical examples for both MySQL and PostgreSQL, demonstrating real-world database development and administration patterns.

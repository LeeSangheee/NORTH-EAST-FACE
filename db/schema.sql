
CREATE DATABASE IF NOT EXISTS NEFDB
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;
USE NEFDB;

-- Schema for NORTH EAST FACE sample shop
-- MySQL-compatible DDL with UTF-8 and InnoDB

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 1) member
CREATE TABLE IF NOT EXISTS member (
  member_id      BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  username       VARCHAR(64) NOT NULL,
  password_hash  VARCHAR(255) NOT NULL,
  email          VARCHAR(255) NOT NULL,
  phone          VARCHAR(32) NOT NULL,
  created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (member_id),
  UNIQUE KEY uk_member_username (username),
  UNIQUE KEY uk_member_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2) product
CREATE TABLE IF NOT EXISTS product (
  product_id   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name         VARCHAR(255) NOT NULL,
  price        DECIMAL(12,2) NOT NULL,
  stock_qty    INT NOT NULL,
  options_json JSON NULL,
  brand        VARCHAR(128) NOT NULL,
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (product_id),
  UNIQUE KEY uk_product_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3) cart_item
CREATE TABLE IF NOT EXISTS cart_item (
  cart_item_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  member_id    BIGINT UNSIGNED NOT NULL,
  product_id   BIGINT UNSIGNED NOT NULL,
  quantity     INT NOT NULL,
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (cart_item_id),
  UNIQUE KEY uk_cart_member_product (member_id, product_id),
  KEY idx_cart_member (member_id),
  KEY idx_cart_product (product_id),
  CONSTRAINT fk_cart_member FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE,
  CONSTRAINT fk_cart_product FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4) orders (use plural to avoid reserved word issues)
CREATE TABLE IF NOT EXISTS orders (
  order_id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  member_id        BIGINT UNSIGNED NOT NULL,
  payment_token    VARCHAR(255) NULL,
  card_last4       CHAR(4) NULL,
  paid_at          DATETIME NOT NULL,
  shipping_address VARCHAR(255) NOT NULL,
  total_amount     DECIMAL(12,2) NOT NULL,
  created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (order_id),
  KEY idx_orders_member (member_id),
  CONSTRAINT fk_orders_member FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5) order_item
CREATE TABLE IF NOT EXISTS order_item (
  order_item_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  order_id      BIGINT UNSIGNED NOT NULL,
  product_id    BIGINT UNSIGNED NOT NULL,
  quantity      INT NOT NULL,
  unit_price    DECIMAL(12,2) NOT NULL,
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (order_item_id),
  KEY idx_order_item_order (order_id),
  KEY idx_order_item_product (product_id),
  CONSTRAINT fk_order_item_order FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  CONSTRAINT fk_order_item_product FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;

-- Sample data
INSERT INTO member (username, password_hash, email, phone) VALUES
  ('alice', '$2y$12$examplehashalice', 'alice@example.com', '010-1111-2222'),
  ('bob',   '$2y$12$examplehashbob__', 'bob@example.com',   '010-3333-4444');

INSERT INTO product (name, price, stock_qty, options_json, brand) VALUES
  ('M\'S HIMALAYAN PARKA (RDS)', 950000.00, 25, JSON_ARRAY('RED/115XXL','BLACK/105','GRAY/100'), 'NORTH EAST FACE'),
  ('W\'S 2000 NUPTSE JACKET',    319200.00, 40, JSON_ARRAY('GRAY/090','BLACK/095'),              'NORTH EAST FACE'),
  ('BOREALIS CLASSIC BACKPACK',  149000.00, 60, JSON_ARRAY('ONE SIZE'),                           'NORTH EAST FACE');

-- Cart items (member 1)
INSERT INTO cart_item (member_id, product_id, quantity) VALUES
  (1, 1, 1),
  (1, 3, 2);

-- Order for member 1
INSERT INTO orders (member_id, payment_token, card_last4, paid_at, shipping_address, total_amount) VALUES
  (1, 'tok_demo_123', '4242', NOW(), 'Seoul Jung-gu Euljiro 100', 950000.00 + 149000.00*2);

-- Order items
INSERT INTO order_item (order_id, product_id, quantity, unit_price) VALUES
  (1, 1, 1, 950000.00),
  (1, 3, 2, 149000.00);

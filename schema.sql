-- ==========================================
-- MASTER RESET & RE-INITIALIZATION SCRIPT
-- ==========================================
-- Warning: This will delete ALL existing data in the tables below.

-- Drop existing tables if they exist
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS admin_users CASCADE;
DROP TABLE IF EXISTS site_content CASCADE;

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Products Table
CREATE TABLE products (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name text NOT NULL,
  price numeric NOT NULL,
  badge text, -- e.g., 'New Arrival', 'Sale', 'Limited'
  images text[] DEFAULT '{}',
  video text,
  is_hidden boolean DEFAULT false,
  category text DEFAULT 'General',
  description text,
  stock_quantity int DEFAULT 10,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Orders Table
CREATE TABLE orders (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  customer_name text NOT NULL,
  customer_phone text NOT NULL,
  customer_address text NOT NULL,
  product_id uuid REFERENCES products(id) ON DELETE SET NULL,
  product_name text,
  total_price numeric NOT NULL,
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'shipped', 'delivered', 'cancelled')),
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Admin Users Table
CREATE TABLE admin_users (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  username text UNIQUE NOT NULL,
  password text NOT NULL, -- Stored as plain text as per user request
  role text DEFAULT 'admin' CHECK (role IN ('admin', 'subadmin')),
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. Site Content Table
CREATE TABLE site_content (
  id int PRIMARY KEY DEFAULT 1,
  data jsonb NOT NULL,
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
  CONSTRAINT single_row CHECK (id = 1)
);

-- ==========================================
-- INITIAL DATA SEEDING
-- ==========================================

-- 1. Create Default Admin
INSERT INTO admin_users (username, password, role) 
VALUES ('Abdullah', '291700ab', 'admin');

-- 2. Create Default Site Configuration
INSERT INTO site_content (id, data) 
VALUES (1, '{
  "brandName": "AS-PRODUCTS",
  "heroTitle": "AS-PRODUCTS LUXURY",
  "heroSub": "Experience the Pinnacle of Premium Quality and Style",
  "heroBg": "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&q=80&w=1500",
  "footerDesc": "We bring you the finest premium products with a commitment to quality and customer satisfaction. Experience luxury like never before.",
  "saleBanner": {"text": "FLASH SALE: 20% OFF ON ALL ITEMS!", "enabled": true},
  "footerContact": {
    "phone": "+92 300 2749065", 
    "email": "info@as-products.com", 
    "address": "Faisalabad, Pakistan", 
    "whatsapp": "923002749065", 
    "instagram": "as_products_official"
  }
}'::jsonb);

-- 3. Create Sample Products
INSERT INTO products (name, price, badge, category, images, description)
VALUES 
('Classic Leather Watch', 4500, 'Best Seller', 'Accessories', ARRAY['https://images.unsplash.com/photo-1524592094714-0f0654e20314?auto=format&fit=crop&w=800'], 'A timeless piece for the modern gentleman.'),
('Premium Cotton Shirt', 2800, 'New', 'Apparel', ARRAY['https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=800'], 'Breathable, stylish, and perfect for any occasion.'),
('Handcrafted Leather Wallet', 1500, 'Trending', 'Accessories', ARRAY['https://images.unsplash.com/photo-1627123424574-724758594e93?auto=format&fit=crop&w=800'], 'Elegance that fits in your pocket.');

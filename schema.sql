-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Products Table
CREATE TABLE IF NOT EXISTS products (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name text NOT NULL,
  price numeric NOT NULL,
  badge text,
  images text[] DEFAULT '{}',
  video text,
  is_hidden boolean DEFAULT false,
  category text,
  description text,
  stock_quantity int DEFAULT 10,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Orders Table
CREATE TABLE IF NOT EXISTS orders (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  customer_name text NOT NULL,
  customer_phone text NOT NULL,
  customer_address text NOT NULL,
  product_id uuid REFERENCES products(id) ON DELETE SET NULL,
  product_name text, -- Fallback if product is deleted
  total_price numeric NOT NULL,
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'shipped', 'delivered', 'cancelled')),
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Admin Users Table
-- Storing passwords in plain text as requested for admin visibility
CREATE TABLE IF NOT EXISTS admin_users (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  username text UNIQUE NOT NULL,
  password text NOT NULL,
  role text DEFAULT 'admin' CHECK (role IN ('admin', 'subadmin')),
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. Site Content Table (Single row for site configuration)
CREATE TABLE IF NOT EXISTS site_content (
  id int PRIMARY KEY DEFAULT 1,
  data jsonb NOT NULL,
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
  CONSTRAINT single_row CHECK (id = 1)
);

-- 5. Initial Data Setup
INSERT INTO admin_users (username, password, role) 
VALUES ('Abdullah', '291700ab', 'admin')
ON CONFLICT (username) DO NOTHING;

INSERT INTO site_content (id, data) 
VALUES (1, '{
  "brandName": "AS-PRODUCTS",
  "heroTitle": "AS-PRODUCTS",
  "heroSub": "Elevating Your Lifestyle with Premium Essentials",
  "heroBg": "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&q=80&w=1500",
  "footerDesc": "We bring you the finest premium products with a commitment to quality and customer satisfaction. Experience luxury like never before.",
  "saleBanner": {"text": "FLASH SALE: 20% OFF ON ALL ITEMS!", "enabled": true},
  "chatbot": {"welcome": "Welcome! How can we assist you today?", "options": []},
  "footerContact": {
    "phone": "+92 300 2749065", 
    "email": "info@as-products.com", 
    "address": "Faisalabad, Pakistan", 
    "whatsapp": "923002749065", 
    "instagram": "as_products_official"
  }
}'::jsonb)
ON CONFLICT (id) DO NOTHING;

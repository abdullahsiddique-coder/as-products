-- 1. Table for website content (already exists, but ensuring structure)
CREATE TABLE IF NOT EXISTS site_content (
  id bigint primary key default 1,
  data jsonb not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2. Table for admin and sub-admin users
-- Note: Storing passwords in plain text as requested for admin visibility
CREATE TABLE IF NOT EXISTS admin_users (
  id uuid primary key default gen_random_uuid(),
  username text unique not null,
  password text not null,
  role text not null check (role in ('admin', 'subadmin')),
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 3. Initial Admin User (Change these after first login)
-- Username: Abdullah, Password: [YOUR-MASTER-PASSWORD]
-- Use the following SQL to insert the initial admin if the table is empty:
-- INSERT INTO admin_users (username, password, role) 
-- VALUES ('Abdullah', '291700ab', 'admin')
-- ON CONFLICT (username) DO NOTHING;

-- 4. Storage Bucket Configuration
-- Ensure a bucket named 'products' exists and is public.
-- This can be done via the Supabase Dashboard under Storage.

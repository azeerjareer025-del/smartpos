create extension if not exists pgcrypto;

create table if not exists profiles(
 id uuid primary key references auth.users(id) on delete cascade,
 full_name text, role text not null default 'cashier' check(role in('admin','manager','cashier')),
 created_at timestamptz default now()
);
create table if not exists categories(
 id uuid primary key default gen_random_uuid(), name text unique not null,
 created_at timestamptz default now()
);
create table if not exists suppliers(
 id uuid primary key default gen_random_uuid(), name text not null,
 contact_person text, phone text, email text, address text,
 outstanding_balance numeric(14,2) default 0, notes text, created_at timestamptz default now()
);
create table if not exists customers(
 id uuid primary key default gen_random_uuid(), customer_code text unique,
 name text not null, phone text, email text, address text,
 credit_limit numeric(14,2) default 0, outstanding_balance numeric(14,2) default 0,
 created_at timestamptz default now()
);
create table if not exists products(
 id uuid primary key default gen_random_uuid(), product_code text unique,
 barcode text unique, name text not null, category_id uuid references categories(id),
 supplier_id uuid references suppliers(id), brand text,
 cost_price numeric(14,2) default 0, selling_price numeric(14,2) not null default 0,
 wholesale_price numeric(14,2), current_stock numeric(14,3) default 0,
 minimum_stock numeric(14,3) default 0, maximum_stock numeric(14,3),
 unit text default 'pcs', status text default 'active', image_url text,
 created_at timestamptz default now(), updated_at timestamptz default now()
);
create table if not exists purchases(
 id uuid primary key default gen_random_uuid(), purchase_number text unique not null,
 supplier_id uuid references suppliers(id), purchase_date date default current_date,
 total numeric(14,2) default 0, payment_status text default 'unpaid',
 created_by uuid references profiles(id), created_at timestamptz default now()
);
create table if not exists purchase_items(
 id uuid primary key default gen_random_uuid(), purchase_id uuid references purchases(id) on delete cascade,
 product_id uuid references products(id), quantity numeric(14,3) not null,
 cost_price numeric(14,2) not null, total numeric(14,2) not null
);
create table if not exists sales(
 id uuid primary key default gen_random_uuid(), invoice_number text unique not null,
 customer_id uuid references customers(id), cashier_id uuid references profiles(id),
 subtotal numeric(14,2) default 0, discount numeric(14,2) default 0,
 total numeric(14,2) not null, payment_method text not null,
 payment_status text default 'paid', cash_received numeric(14,2) default 0,
 change_amount numeric(14,2) default 0, status text default 'completed',
 created_at timestamptz default now()
);
create table if not exists sale_items(
 id uuid primary key default gen_random_uuid(), sale_id uuid references sales(id) on delete cascade,
 product_id uuid references products(id), product_name text not null,
 quantity numeric(14,3) not null, unit_price numeric(14,2) not null,
 cost_price numeric(14,2) default 0, total numeric(14,2) not null
);
create table if not exists payments(
 id uuid primary key default gen_random_uuid(), sale_id uuid references sales(id),
 customer_id uuid references customers(id), amount numeric(14,2) not null,
 method text not null, payment_date timestamptz default now(), notes text
);
create table if not exists expenses(
 id uuid primary key default gen_random_uuid(), expense_date date default current_date,
 category text not null, description text, amount numeric(14,2) not null,
 payment_method text, notes text, created_by uuid references profiles(id),
 created_at timestamptz default now()
);
create table if not exists stock_movements(
 id uuid primary key default gen_random_uuid(), product_id uuid references products(id),
 movement_type text not null, quantity numeric(14,3) not null,
 reference_type text, reference_id uuid, notes text, created_by uuid references profiles(id),
 created_at timestamptz default now()
);
create table if not exists settings(
 id integer primary key default 1, shop_name text default 'SmartPOS Shop',
 logo_url text, address text, phone text, email text, currency text default 'LKR',
 tax_rate numeric(8,2) default 0, receipt_footer text default 'Thank you for your business!',
 invoice_prefix text default 'INV-', starting_invoice_number bigint default 1001,
 low_stock_level numeric(14,3) default 5, date_format text default 'DD/MM/YYYY',
 receipt_size text default '80mm'
);
create table if not exists audit_logs(
 id uuid primary key default gen_random_uuid(), user_id uuid references profiles(id),
 action text not null, entity_type text, entity_id uuid, created_at timestamptz default now()
);

-- Starter categories
insert into categories(name) values
('Electronics'),('Home Appliances'),('Gifts'),('Cosmetics'),('Perfumes'),
('Watches'),('Accessories'),('General')
on conflict(name) do nothing;

insert into settings(id) values(1) on conflict(id) do nothing;

-- ============================================================
-- WHITE LINE AIRWAYS — SUPABASE UPDATE
-- Run this in Supabase Dashboard → SQL Editor → New Query
-- ============================================================

-- 1. CUSTOMERS TABLE (Master Database)
create table if not exists customers (
  id              uuid default gen_random_uuid() primary key,
  name            text not null,
  phone           text not null,
  company         text,
  email           text,
  city            text,
  wa_notifications boolean default true,
  created_at      timestamptz default now(),
  updated_at      timestamptz default now()
);
create unique index if not exists customers_name_idx on customers(lower(name));

-- 2. SHIPMENTS TABLE
create table if not exists shipments (
  id            uuid default gen_random_uuid() primary key,
  booking_date  date,
  docket_no     text not null unique,
  customer_name text,
  origin        text,
  destination   text,
  train_number  text,
  bags          integer,
  weight        numeric,
  status        text default 'Booked',
  remarks       text,
  wa_sent       boolean default false,
  last_wa_status text,
  created_at    timestamptz default now(),
  updated_at    timestamptz default now()
);

-- 3. ROW LEVEL SECURITY
alter table customers enable row level security;
alter table shipments  enable row level security;

-- Allow anon full access (admin dashboard uses anon key)
create policy "Anon full access customers"
  on customers for all using (true) with check (true);

create policy "Anon full access shipments"
  on shipments for all using (true) with check (true);

-- 4. Insert sample customers (match your Excel sample)
insert into customers (name, phone, company, city, wa_notifications) values
  ('ABCD', '919999999999', 'ABCD Enterprises', 'Delhi', true)
on conflict do nothing;

-- Done! Tables created.
-- Next: Go to Admin Dashboard → Customers → Add your real customers
-- Then: Admin Dashboard → Shipments → Upload Excel

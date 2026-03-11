-- ============================================================
-- WHITE LINE AIRWAYS — SUPABASE DATABASE SETUP
-- Run this in Supabase Dashboard → SQL Editor → New Query
-- ============================================================

-- 1. BLOG POSTS TABLE
create table if not exists blog_posts (
  id uuid default gen_random_uuid() primary key,
  title text not null,
  slug text not null unique,
  excerpt text,
  content text,
  category text default 'logistics',
  author text default 'White Line Airways Team',
  date date default current_date,
  image text,
  tags text[],
  meta_desc text,
  status text default 'published',
  read_time text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 2. LEADS TABLE (form submissions)
create table if not exists leads (
  id uuid default gen_random_uuid() primary key,
  form_type text not null, -- 'quote', 'contact', 'home'
  name text,
  phone text,
  email text,
  company text,
  message text,
  freight_type text,
  origin text,
  destination text,
  business_type text,
  subject text,
  status text default 'new', -- 'new', 'contacted', 'closed'
  notes text,
  created_at timestamptz default now()
);

-- 3. ADMIN USERS TABLE
create table if not exists admin_users (
  id uuid default gen_random_uuid() primary key,
  username text not null unique,
  password_hash text not null,
  created_at timestamptz default now()
);

-- 4. Insert default admin (password: wla@2024)
insert into admin_users (username, password_hash)
values ('admin', 'wla2024_hashed')
on conflict (username) do nothing;

-- 5. Insert sample blog posts
insert into blog_posts (title, slug, excerpt, content, category, author, date, tags, meta_desc, status, read_time) values
(
  'Why Air Freight is the Best Choice for North East India Deliveries',
  'air-freight-north-east-india',
  'North East India presents unique logistics challenges — difficult terrain, seasonal road closures, and limited rail connectivity. Here''s why air freight is often the smartest choice.',
  '<h2>The North East India Logistics Challenge</h2><p>Delivering goods to India''s North East region is unlike any other logistics operation in the country. With eight states separated from the mainland by narrow corridors, unpredictable monsoons, and mountainous terrain, the region demands specialized expertise.</p><h2>Why Air Freight Wins</h2><p>At White Line Airways, we''ve spent 30+ years perfecting North East deliveries. Air freight offers the fastest transit times — typically 12 to 48 hours.</p><ul><li>Unaffected by road conditions or flooding</li><li>Consistent transit times year-round</li><li>Ideal for time-sensitive cargo</li><li>Reduced damage risk with professional cargo handling</li></ul><div class="blog-post-cta"><strong>Need a freight quote for North East India?</strong><br><br><a href="#" onclick="showPage(''quote'');closeBlogModal();return false;" style="display:inline-block;background:var(--red);color:white;padding:12px 28px;border-radius:8px;text-decoration:none;font-weight:700;margin-top:12px;">Get a Free Quote</a></div>',
  'northeast', 'White Line Airways Team', '2025-11-15',
  array['air freight', 'North East India', 'logistics'],
  'Discover why air freight is the most reliable logistics solution for North East India. White Line Airways covers all 8 NE states with 12-48hr TAT.',
  'published', '4 min read'
),
(
  '5 Ways to Reduce Your Freight Costs Without Compromising on Speed',
  'reduce-freight-costs-tips',
  'Smart logistics planning can significantly cut your freight bill. Our experts share 5 proven strategies that consistently reduce costs while maintaining fast delivery windows.',
  '<h2>Smart Freight Planning Saves Money</h2><p>In today''s competitive market, logistics costs can make or break your business margins. We''ve identified five strategies that consistently reduce freight costs.</p><h2>1. Consolidate Your Shipments</h2><p>Instead of sending multiple small shipments, consolidate them. Our PTL and cargo consolidation services are designed exactly for this.</p><h2>2. Plan Ahead</h2><p>Last-minute bookings always cost more. Planning 48-72 hours ahead allows us to optimise routing and offer better rates.</h2><h2>3. Choose the Right Mode</h2><p>Not every shipment needs air freight. For non-urgent cargo, rail is 30-40% cheaper.</p><div class="blog-post-cta"><strong>Ready to optimise your logistics spend?</strong><br><br><a href="#" onclick="showPage(''contact'');closeBlogModal();return false;" style="display:inline-block;background:var(--red);color:white;padding:12px 28px;border-radius:8px;text-decoration:none;font-weight:700;margin-top:12px;">Talk to Our Team</a></div>',
  'tips', 'White Line Airways Team', '2025-10-28',
  array['freight costs', 'logistics tips', 'cost saving'],
  '5 expert tips to reduce freight costs without slowing delivery. From cargo consolidation to multi-modal routing.',
  'published', '5 min read'
),
(
  'Rail Freight vs Air Freight: Which is Right for Your Business?',
  'rail-freight-vs-air-freight-comparison',
  'Choosing between rail and air for your cargo can be confusing. We break down the key differences in cost, speed, and cargo types to help you decide.',
  '<h2>The Core Trade-off: Speed vs Cost</h2><p>The choice between air and rail freight comes down to two variables: how fast you need it and how much you''re willing to spend.</p><h2>Air Freight: Speed is King</h2><p>Air freight is the fastest mode. Delhi to Guwahati in under 24 hours.</p><ul><li><strong>Transit time:</strong> 12-72 hours</li><li><strong>Cost:</strong> Higher per kg</li><li><strong>Best for:</strong> Urgent, high-value cargo</li></ul><h2>Rail Cargo: Efficient and Reliable</h2><p>Rail freight is significantly cheaper for bulk cargo.</p><ul><li><strong>Transit time:</strong> 2-5 days</li><li><strong>Cost:</strong> 30-50% cheaper than air</li><li><strong>Best for:</strong> Bulk cargo, non-perishables</li></ul><div class="blog-post-cta"><strong>Not sure which mode is right for you?</strong><br><br><a href="#" onclick="showPage(''contact'');closeBlogModal();return false;" style="display:inline-block;background:var(--red);color:white;padding:12px 28px;border-radius:8px;text-decoration:none;font-weight:700;margin-top:12px;">Ask Our Experts</a></div>',
  'logistics', 'White Line Airways Team', '2025-08-22',
  array['rail freight', 'air freight', 'comparison'],
  'Air freight vs rail freight — complete comparison of speed, cost, and best use cases for your business.',
  'published', '5 min read'
)
on conflict (slug) do nothing;

-- 6. ROW LEVEL SECURITY — allow public read of published posts
alter table blog_posts enable row level security;
alter table leads enable row level security;
alter table admin_users enable row level security;

-- Public can read published blog posts
create policy "Public can read published posts"
  on blog_posts for select
  using (status = 'published');

-- Anyone can insert leads (form submissions)
create policy "Anyone can insert leads"
  on leads for insert
  with check (true);

-- Anon can do all on blog_posts (for admin - tighten later with auth)
create policy "Anon full access blog_posts"
  on blog_posts for all
  using (true)
  with check (true);

-- Anon can read leads
create policy "Anon can read leads"
  on leads for select
  using (true);

-- Anon can update leads (status changes)
create policy "Anon can update leads"
  on leads for update
  using (true);

-- Admin users readable by anon (for login check)
create policy "Anon can read admin_users"
  on admin_users for select
  using (true);

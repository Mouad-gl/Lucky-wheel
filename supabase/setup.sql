-- Run this in your Supabase SQL editor (https://supabase.com/dashboard/project/iyzjyxlegljwcbmayhqq/sql)

-- ─── wheel_config table ───────────────────────────────────────────────────────
create table if not exists wheel_config (
  id          integer primary key default 1,
  brand_name  text    default 'LUCKY WHEEL',
  logo_url    text,
  bg_url      text,
  color1      text    default '#00E676',
  color2      text    default '#000000',
  show_labels boolean default true,
  show_store  boolean default true,
  app_store_label   text default 'Download on the',
  app_store_url     text,
  google_play_label text default 'Get it on',
  google_play_url   text,
  wheel_bg_color    text    default '#111111',
  wheel_bg_url      text,
  entries     jsonb   default '["Prize 1","Prize 2","Prize 3","Prize 4","Prize 5","Prize 6","Prize 7","Prize 8"]',
  updated_at  timestamptz default now()
);

alter table wheel_config add column if not exists wheel_bg_color  text    default '#111111';
alter table wheel_config add column if not exists wheel_bg_url    text;
alter table wheel_config add column if not exists wheel_bg_offset numeric default 0;
alter table wheel_config add column if not exists spin_speed      numeric default 3;
alter table wheel_config add column if not exists spin_btn_url    text;

insert into wheel_config (id) values (1) on conflict (id) do nothing;

alter table wheel_config enable row level security;
create policy "public_read"   on wheel_config for select using (true);
create policy "public_update" on wheel_config for update using (true);
grant select, update on wheel_config to anon;

-- ─── Storage bucket for wheel images ─────────────────────────────────────────
-- 1. Go to Storage in your Supabase dashboard and create a bucket named
--    "wheel-images" with "Public bucket" checked.
--    OR run the insert below (requires service role):
-- insert into storage.buckets (id, name, public) values ('wheel-images', 'wheel-images', true)
--   on conflict (id) do nothing;

-- 2. Run these policies so the anon key can upload and read images:
create policy "anon_upload" on storage.objects
  for insert to anon
  with check (bucket_id = 'wheel-images');

create policy "anon_read" on storage.objects
  for select to anon
  using (bucket_id = 'wheel-images');

create policy "anon_delete" on storage.objects
  for delete to anon
  using (bucket_id = 'wheel-images');

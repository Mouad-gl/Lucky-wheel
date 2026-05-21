-- Run this in your Supabase SQL editor (https://supabase.com/dashboard/project/iyzjyxlegljwcbmayhqq/sql)

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

-- If the table already exists, add the new columns:
alter table wheel_config add column if not exists wheel_bg_color text default '#111111';
alter table wheel_config add column if not exists wheel_bg_url   text;

-- Seed the single config row
insert into wheel_config (id) values (1) on conflict (id) do nothing;

-- RLS: anyone can read, anyone can update (public wheel config)
alter table wheel_config enable row level security;

create policy "public_read"   on wheel_config for select using (true);
create policy "public_update" on wheel_config for update using (true);

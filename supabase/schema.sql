-- Run this entire file in your Supabase Dashboard -> SQL Editor

-- ── PROFILES TABLE ──
create table profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  anonymous_id text,
  name text default '',
  phone text default '',
  country text default 'Tanzania',
  city text default 'Arusha',
  occupation text default '',
  is_onboarded boolean default false,
  score int default 300,
  tier text default 'Bronze',
  is_dark boolean default false,
  currency_code text default 'TZS',
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- ── TRANSACTIONS TABLE ──
create table transactions (
  id bigint primary key generated always as identity,
  user_id uuid references profiles(id) on delete cascade not null,
  type text not null,
  label text not null,
  amount double precision not null,
  date text not null,
  category text not null,
  created_at timestamp with time zone default now()
);

-- ── ROW LEVEL SECURITY ──
alter table profiles enable row level security;
alter table transactions enable row level security;

-- Profiles policies
create policy "Users can view own profile"
  on profiles for select
  using (auth.uid() = id);

create policy "Users can insert own profile"
  on profiles for insert
  with check (auth.uid() = id);

create policy "Users can update own profile"
  on profiles for update
  using (auth.uid() = id);

-- Transactions policies
create policy "Users can view own transactions"
  on transactions for select
  using (auth.uid() = user_id);

create policy "Users can insert own transactions"
  on transactions for insert
  with check (auth.uid() = user_id);

create policy "Users can update own transactions"
  on transactions for update
  using (auth.uid() = user_id);

create policy "Users can delete own transactions"
  on transactions for delete
  using (auth.uid() = user_id);

-- ── AUTO-CREATE PROFILE ON SIGNUP ──
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id)
  values (new.id);
  return new;
end;
$$;

create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

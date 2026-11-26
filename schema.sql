-- Run in Supabase SQL Editor. Add staff accounts in Authentication, then assign roles below.
create extension if not exists pgcrypto;
create table if not exists public.portal_settings(id int primary key default 1 check(id=1), registrations_open boolean not null default false);
insert into public.portal_settings(id,registrations_open) values(1,false) on conflict(id) do nothing;
create table if not exists public.events(id uuid primary key default gen_random_uuid(),name text not null,category text not null check(category in ('sports','cultural')),enabled boolean not null default true,created_at timestamptz not null default now());
create table if not exists public.registrations(id uuid primary key default gen_random_uuid(),full_name text not null check(length(trim(full_name)) between 2 and 100),roll_number text not null unique check(length(trim(roll_number)) between 1 and 40),created_at timestamptz not null default now());
create table if not exists public.registration_events(registration_id uuid not null references public.registrations(id) on delete cascade,event_id uuid not null references public.events(id) on delete cascade,primary key(registration_id,event_id));
create table if not exists public.management_profiles(id uuid primary key references auth.users(id) on delete cascade,role text not null check(role in ('captain','vice_captain','volunteer','teacher')),created_at timestamptz not null default now());
create table if not exists public.audit_logs(id uuid primary key default gen_random_uuid(),actor uuid references auth.users(id),action text not null,details jsonb not null default '{}',created_at timestamptz not null default now());
create or replace function public.is_manager() returns boolean language sql stable security definer set search_path=public as $$ select exists(select 1 from management_profiles where id=auth.uid()) $$;
create or replace function public.is_leader() returns boolean language sql stable security definer set search_path=public as $$ select exists(select 1 from management_profiles where id=auth.uid() and role in ('captain','vice_captain')) $$;
create or replace function public.register_student(p_full_name text,p_roll_number text,p_event_ids uuid[]) returns json language plpgsql security definer set search_path=public as $$
declare rid uuid; begin
 if not (select registrations_open from portal_settings where id=1) then raise exception 'Registrations are closed'; end if;
 if length(trim(p_full_name))<2 or length(trim(p_full_name))>100 or length(trim(p_roll_number))<1 or length(trim(p_roll_number))>40 then raise exception 'Please enter valid name and roll number'; end if;
 if coalesce(array_length(p_event_ids,1),0)<1 or array_length(p_event_ids,1)>30 then raise exception 'Select between 1 and 30 events'; end if;
 if exists(select 1 from events where id=any(p_event_ids) and enabled=false) or (select count(*) from events where id=any(p_event_ids))<>array_length(p_event_ids,1) then raise exception 'One or more events are unavailable'; end if;
 insert into registrations(full_name,roll_number) values(trim(p_full_name),trim(p_roll_number)) returning id into rid;
 insert into registration_events(registration_id,event_id) select rid,x from unnest(p_event_ids) x;
 return json_build_object('message','Registration submitted successfully'); exception when unique_violation then raise exception 'This roll number is already registered'; end $$;
create or replace function public.set_registration_status(p_open boolean) returns void language plpgsql security definer set search_path=public as $$ begin if not is_leader() then raise exception 'Insufficient permission'; end if; update portal_settings set registrations_open=p_open where id=1; insert into audit_logs(actor,action,details) values(auth.uid(),'registration_status',jsonb_build_object('open',p_open)); end $$;
-- RLS
alter table portal_settings enable row level security;alter table events enable row level security;alter table registrations enable row level security;alter table registration_events enable row level security;alter table management_profiles enable row level security;alter table audit_logs enable row level security;
create policy settings_public_read on portal_settings for select to anon,authenticated using(true);
create policy settings_manager_update on portal_settings for update to authenticated using(is_leader()) with check(is_leader());
create policy events_public_read on events for select to anon,authenticated using(true);
create policy events_manager_write on events for all to authenticated using(is_manager()) with check(is_manager());
create policy registrations_manager_read on registrations for select to authenticated using(is_manager());
create policy registrations_manager_modify on registrations for all to authenticated using(is_manager()) with check(is_manager());
create policy selections_manager_read on registration_events for select to authenticated using(is_manager());
create policy selections_manager_modify on registration_events for all to authenticated using(is_manager()) with check(is_manager());
create policy profiles_self_or_leader_read on management_profiles for select to authenticated using(id=auth.uid() or is_leader());
create policy profile_leader_manage on management_profiles for all to authenticated using(is_leader()) with check(is_leader());
create policy logs_leader_read on audit_logs for select to authenticated using(is_leader());
create policy logs_manager_insert on audit_logs for insert to authenticated with check(is_manager() and actor=auth.uid());
-- Restrict function execution
revoke all on function public.register_student(text,text,uuid[]) from public;grant execute on function public.register_student(text,text,uuid[]) to anon,authenticated;
revoke all on function public.set_registration_status(boolean) from public;grant execute on function public.set_registration_status(boolean) to authenticated;
-- Seed event names only; no participant data.
insert into events(name,category) values ('100 m','sports'),('200 m','sports'),('400 m','sports'),('Relay','sports'),('Long Jump','sports'),('High Jump','sports'),('Football','sports'),('Basketball','sports'),('Volleyball','sports'),('Badminton','sports'),('Chess','sports'),('Carrom','sports'),('Singing','cultural'),('Dance','cultural'),('Drama','cultural'),('Poetry Recitation','cultural'),('Quiz','cultural'),('Art','cultural') on conflict do nothing;

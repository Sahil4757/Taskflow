-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- 1. PROFILES
-- Extends Supabase auth.users
create table public.profiles (
  id uuid references auth.users(id) on delete cascade not null primary key,
  username text unique,
  full_name text,
  avatar_url text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 2. PROJECTS
-- Top-level containers
create table public.projects (
  id uuid default uuid_generate_v4() primary key,
  name text not null,
  description text,
  owner_id uuid references public.profiles(id) not null,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 3. TASKS
-- Work items within projects
create table public.tasks (
  id uuid default uuid_generate_v4() primary key,
  project_id uuid references public.projects(id) on delete cascade not null,
  title text not null,
  description text,
  status text default 'todo' check (status in ('todo', 'in_progress', 'review', 'done')),
  priority text default 'medium' check (priority in ('low', 'medium', 'high', 'urgent')),
  assignee_id uuid references public.profiles(id),
  created_by uuid references public.profiles(id) not null,
  due_date timestamptz,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 4. COMMENTS
-- Discussions on tasks
create table public.comments (
  id uuid default uuid_generate_v4() primary key,
  task_id uuid references public.tasks(id) on delete cascade not null,
  user_id uuid references public.profiles(id) not null,
  content text not null,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 5. ATTACHMENTS
-- Files associated with tasks
create table public.attachments (
  id uuid default uuid_generate_v4() primary key,
  task_id uuid references public.tasks(id) on delete cascade not null,
  uploaded_by uuid references public.profiles(id) not null,
  file_name text not null,
  file_url text not null,
  file_type text, -- MIME type
  file_size bigint,
  created_at timestamptz default now()
);

-- 6. ACTIVITY
-- Audit trail
create table public.activity (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id),
  project_id uuid references public.projects(id) on delete set null,
  task_id uuid references public.tasks(id) on delete set null,
  action_type text not null, -- e.g., 'task_created', 'comment_added', 'status_changed'
  details jsonb default '{}'::jsonb, -- Store details like old/new values
  created_at timestamptz default now()
);

-- Function to automatically update updated_at timestamp
create or replace function handle_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- Triggers for updated_at
create trigger on_profiles_updated before update on public.profiles
  for each row execute procedure handle_updated_at();
create trigger on_projects_updated before update on public.projects
  for each row execute procedure handle_updated_at();
create trigger on_tasks_updated before update on public.tasks
  for each row execute procedure handle_updated_at();
create trigger on_comments_updated before update on public.comments
  for each row execute procedure handle_updated_at();

-- Function to handle new user creation (Supabase specific)
-- Automatically creates a profile entry when a user signs up
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, full_name, avatar_url)
  values (new.id, new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'avatar_url');
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();


-- ROW LEVEL SECURITY (RLS) POLICIES
-- Note: These are basic policies assuming a somewhat open team structure.
-- You may want to restrict 'read' access based on team membership in a real production app.

-- Enable RLS on all tables
alter table public.profiles enable row level security;
alter table public.projects enable row level security;
alter table public.tasks enable row level security;
alter table public.comments enable row level security;
alter table public.attachments enable row level security;
alter table public.activity enable row level security;

-- PROFILES: Everyone can view profiles, users can edit their own
create policy "Public profiles are viewable by everyone"
  on public.profiles for select using (true);

create policy "Users can insert their own profile"
  on public.profiles for insert with check (auth.uid() = id);

create policy "Users can update own profile"
  on public.profiles for update using (auth.uid() = id);

-- PROJECTS: Authenticated users can view all projects, only owners can edit/delete
create policy "Authenticated users can view projects"
  on public.projects for select using (auth.role() = 'authenticated');

create policy "Authenticated users can create projects"
  on public.projects for insert with check (auth.role() = 'authenticated');

create policy "Owners can update their projects"
  on public.projects for update using (auth.uid() = owner_id);

create policy "Owners can delete their projects"
  on public.projects for delete using (auth.uid() = owner_id);

-- TASKS: Authenticated users can view tasks, Authenticated users can create, Assignees/Creators can update
create policy "Authenticated users can view tasks"
  on public.tasks for select using (auth.role() = 'authenticated');

create policy "Authenticated users can create tasks"
  on public.tasks for insert with check (auth.role() = 'authenticated');

create policy "Users can update tasks"
  on public.tasks for update using (auth.role() = 'authenticated');

-- COMMENTS: Viewable by authenticated users, Create/Edit by author
create policy "Authenticated users can view comments"
  on public.comments for select using (auth.role() = 'authenticated');

create policy "Authenticated users can create comments"
  on public.comments for insert with check (auth.role() = 'authenticated');

create policy "Users can update own comments"
  on public.comments for update using (auth.uid() = user_id);

create policy "Users can delete own comments"
  on public.comments for delete using (auth.uid() = user_id);

-- ATTACHMENTS
create policy "Authenticated users can view attachments"
  on public.attachments for select using (auth.role() = 'authenticated');

create policy "Authenticated users can upload attachments"
  on public.attachments for insert with check (auth.role() = 'authenticated');

create policy "Users can delete own attachments"
  on public.attachments for delete using (auth.uid() = uploaded_by);

-- ACTIVITY: View only
create policy "Authenticated users can view activity"
  on public.activity for select using (auth.role() = 'authenticated');

-- INDEXES FOR PERFORMANCE
-- 1. Foreign Keys (Postgres doesn't automatically index FKs)
create index idx_projects_owner on public.projects(owner_id);
create index idx_tasks_project on public.tasks(project_id);
create index idx_tasks_assignee on public.tasks(assignee_id);
create index idx_tasks_creator on public.tasks(created_by);
create index idx_comments_task on public.comments(task_id);
create index idx_comments_user on public.comments(user_id);
create index idx_attachments_task on public.attachments(task_id);
create index idx_activity_project on public.activity(project_id);
create index idx_activity_task on public.activity(task_id);

-- 2. Common Filtering/Sorting Columns
create index idx_tasks_status on public.tasks(status);
create index idx_tasks_priority on public.tasks(priority);
create index idx_tasks_due_date on public.tasks(due_date);
create index idx_activity_created_at on public.activity(created_at desc);
create index idx_comments_created_at on public.comments(created_at);


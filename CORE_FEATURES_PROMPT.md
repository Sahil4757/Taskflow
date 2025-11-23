# TaskFlow Core Features Implementation Prompt

## Overview
Build the core functionality for TaskFlow - a task and project management app. Focus on getting these essential features working well before adding advanced features.

## Core Features to Implement

### 1. ✅ User Authentication (Partially Done)
**Current Status:** Sign-in and sign-up pages exist

**What's Needed:**
- Complete the authentication flow:
  - Connect sign-in/sign-up forms to Supabase Auth
  - Handle authentication errors and show user-friendly messages
  - Redirect authenticated users to dashboard
  - Redirect unauthenticated users to sign-in page
- User session management:
  - Load user data in `+layout.server.ts`
  - Show actual user name/email in header and sidebar (replace "John Doe")
  - Implement logout functionality
- Protect routes:
  - Only authenticated users can access dashboard, tasks, projects
  - Unauthenticated users redirected to sign-in

**Files to Update:**
- `src/routes/sign-in/+page.server.ts` - Connect to Supabase
- `src/routes/signup/+page.server.ts` - Connect to Supabase
- `src/routes/+layout.server.ts` - Load user session
- `src/lib/components/layout/Header.svelte` - Show real user data
- `src/lib/components/layout/Sidebar.svelte` - Show real user data, add logout

---
TODO...
### 2. Task Management

**Create Task Pages:**
- **`/tasks` route** - Task list page
  - Display all tasks in a table or card view
  - Show: title, project, assignee, status, priority, due date
  - Add "Create Task" button
  - Filter by status (todo, in_progress, review, done)
  - Filter by project
  - Search tasks by title

- **`/tasks/[id]` route** - Task detail page
  - Show full task information
  - Edit task button
  - Delete task button
  - Show comments section (from comments table)
  - Show activity feed (from activity table)

**Create Task API Routes:**
- `src/routes/api/tasks/+server.ts` - GET (list tasks), POST (create task)
- `src/routes/api/tasks/[id]/+server.ts` - GET (get task), PATCH (update), DELETE (delete)

**Create Task Components:**
- `src/lib/components/tasks/TaskList.svelte` - Display list of tasks
- `src/lib/components/tasks/TaskCard.svelte` - Individual task card
- `src/lib/components/tasks/TaskForm.svelte` - Create/edit task form
- `src/lib/components/tasks/TaskDetail.svelte` - Task detail view

**Task Form Fields:**
- Title (required)
- Description (optional)
- Project (dropdown - select from projects)
- Status (dropdown: todo, in_progress, review, done)
- Priority (dropdown: low, medium, high, urgent)
- Assignee (dropdown - select from users/profiles)
- Due Date (date picker)

**Implementation Steps:**
1. Create API routes to fetch/create/update/delete tasks from Supabase
2. Create task list page that fetches and displays tasks
3. Create task form component for creating/editing
4. Create task detail page
5. Add filters and search functionality

---

### 3. Project Management

**Create Project Pages:**
- **`/projects` route** - Project list page
  - Display all projects in a grid or list
  - Show: name, description, task count, owner
  - Add "Create Project" button
  - Click project to view details

- **`/projects/[id]` route** - Project detail page
  - Show project information
  - List all tasks in this project
  - Edit project button
  - Delete project button
  - Show project activity

**Create Project API Routes:**
- `src/routes/api/projects/+server.ts` - GET (list projects), POST (create project)
- `src/routes/api/projects/[id]/+server.ts` - GET, PATCH, DELETE

**Create Project Components:**
- `src/lib/components/projects/ProjectList.svelte` - Display list of projects
- `src/lib/components/projects/ProjectCard.svelte` - Individual project card
- `src/lib/components/projects/ProjectForm.svelte` - Create/edit project form
- `src/lib/components/projects/ProjectDetail.svelte` - Project detail view

**Project Form Fields:**
- Name (required)
- Description (optional)
- Owner (auto-set to current user)

**Implementation Steps:**
1. Create API routes for projects
2. Create project list page
3. Create project form component
4. Create project detail page with tasks list

---

### 4. Activity Feed

**What to Show:**
- Display activity from the `activity` table
- Show on:
  - Dashboard (recent activity)
  - Task detail page (task-specific activity)
  - Project detail page (project-specific activity)

**Activity Types to Track:**
- Task created
- Task updated (status change, assignee change, etc.)
- Task deleted
- Comment added
- Project created
- Project updated

**Create Activity Components:**
- `src/lib/components/activity/ActivityFeed.svelte` - Display list of activities
- `src/lib/components/activity/ActivityItem.svelte` - Individual activity item

**Activity Display Format:**
- "John Doe created task 'Fix bug' in project 'Website'"
- "John Doe changed status of 'Fix bug' from 'todo' to 'in_progress'"
- "John Doe added a comment on 'Fix bug'"
- Show timestamp (e.g., "2 hours ago", "Yesterday")

**Implementation Steps:**
1. Create database triggers or insert activity records when tasks/projects are created/updated
2. Create API route to fetch activity: `src/routes/api/activity/+server.ts`
3. Create activity feed component
4. Add activity feed to dashboard, task detail, and project detail pages

**Note:** You'll need to insert records into the `activity` table when actions happen. You can do this:
- In your API routes after creating/updating tasks/projects
- Or use database triggers (more advanced)

---

### 5. Real-time Collaboration

**What to Implement:**
- Real-time task updates (when someone updates a task, others see it instantly)
- Real-time comments (when someone adds a comment, it appears for everyone)
- Real-time activity feed updates

**Implementation:**
- Use Supabase Realtime subscriptions
- Subscribe to changes on:
  - `tasks` table
  - `comments` table
  - `activity` table

**How to Implement:**
1. In your Svelte components, subscribe to Supabase Realtime:
   ```typescript
   import { supabase } from '$lib/supabase';
   
   // Subscribe to task changes
   const channel = supabase
     .channel('tasks')
     .on('postgres_changes', 
       { event: '*', schema: 'public', table: 'tasks' },
       (payload) => {
         // Update your local state
         console.log('Task changed:', payload);
       }
     )
     .subscribe();
   ```

2. Update your task list/detail components to listen for real-time changes
3. When a change is received, update the UI automatically

**Files to Update:**
- Task list component - subscribe to task changes
- Task detail component - subscribe to task and comment changes
- Activity feed component - subscribe to activity changes

**Note:** Make sure Realtime is enabled in your Supabase project settings.

---

### 6. Dark Mode

**Current Status:** Dark mode classes exist in Tailwind but may not be fully implemented

**What to Implement:**
- Dark mode toggle button (add to header or sidebar)
- Store user preference (localStorage or user profile)
- Apply dark mode classes throughout all components
- Smooth theme transition

**Implementation Steps:**
1. Create a dark mode store:
   - `src/lib/stores/theme.ts` - Store for dark mode state
   - Read from localStorage on load
   - Save to localStorage on change

2. Add toggle button to Header or Sidebar
3. Apply `dark:` classes to all components that need them
4. Ensure all new components support dark mode

**Components to Update:**
- All existing components (DashboardLayout, Header, Sidebar)
- All new components (TaskList, TaskCard, ProjectList, etc.)

-----


------

## Implementation Order (Recommended)

### Week 1: Foundation
1. ✅ Complete authentication (connect forms, add logout, protect routes)
2. Create basic API routes structure
3. Set up Supabase client helper

### Week 2: Task Management
1. Create task API routes (CRUD operations)
2. Create task list page
3. Create task form component
4. Create task detail page

### Week 3: Project Management
1. Create project API routes (CRUD operations)
2. Create project list page
3. Create project form component
4. Create project detail page

### Week 4: Activity Feed & Real-time
1. Implement activity tracking (insert records when actions happen)
2. Create activity feed component
3. Add activity feeds to pages
4. Implement real-time subscriptions

### Week 5: Dark Mode & Polish
1. Implement dark mode toggle
2. Apply dark mode to all components
3. Test and fix any issues
4. Polish UI/UX

---

## Essential Files to Create

### API Routes:
```
src/routes/api/
├── tasks/
│   ├── +server.ts          # GET (list), POST (create)
│   └── [id]/
│       └── +server.ts       # GET, PATCH, DELETE
├── projects/
│   ├── +server.ts          # GET (list), POST (create)
│   └── [id]/
│       └── +server.ts       # GET, PATCH, DELETE
└── activity/
    └── +server.ts          # GET (list activities)
```

### Page Routes:
```
src/routes/
├── tasks/
│   ├── +page.svelte        # Task list
│   └── [id]/
│       └── +page.svelte    # Task detail
└── projects/
    ├── +page.svelte        # Project list
    └── [id]/
        └── +page.svelte    # Project detail
```

### Components:
```
src/lib/components/
├── tasks/
│   ├── TaskList.svelte
│   ├── TaskCard.svelte
│   ├── TaskForm.svelte
│   └── TaskDetail.svelte
├── projects/
│   ├── ProjectList.svelte
│   ├── ProjectCard.svelte
│   ├── ProjectForm.svelte
│   └── ProjectDetail.svelte
└── activity/
    ├── ActivityFeed.svelte
    └── ActivityItem.svelte
```

### Utilities:
```
src/lib/
├── supabase.ts             # Supabase client (if not exists)
└── stores/
    └── theme.ts            # Dark mode store
```

---

## Quick Start Tips

1. **Supabase Client Setup:**
   - Create `src/lib/supabase.ts` with your Supabase client
   - Use environment variables for URL and anon key

2. **API Route Pattern:**
   ```typescript
   // src/routes/api/tasks/+server.ts
   import { json } from '@sveltejs/kit';
   import { supabase } from '$lib/supabase';
   
   export async function GET({ locals }) {
     const { data, error } = await supabase
       .from('tasks')
       .select('*, project:projects(*), assignee:profiles(*)');
     
     if (error) return json({ error: error.message }, { status: 500 });
     return json(data);
   }
   ```

3. **Form Handling:**
   - Use SvelteKit form actions (`+page.server.ts`)
   - Or use API routes with fetch from client
   - Show loading states and error messages

4. **Real-time Setup:**
   - Enable Realtime in Supabase dashboard
   - Subscribe in `onMount` and unsubscribe in `onDestroy`

5. **Dark Mode:**
   - Use Tailwind's `dark:` prefix
   - Toggle `dark` class on `<html>` element
   - Store preference in localStorage

---

## Success Checklist

- [ ] Users can sign in/sign up and stay logged in
- [ ] Users can create, view, edit, and delete tasks
- [ ] Users can create, view, edit, and delete projects
- [ ] Tasks are linked to projects
- [ ] Activity feed shows recent actions
- [ ] Real-time updates work (test with two browsers)
- [ ] Dark mode toggle works and persists
- [ ] All pages are protected (require authentication)
- [ ] User's actual name/email shows in header/sidebar
- [ ] Logout works correctly

---

## Resources

- [SvelteKit Docs](https://kit.svelte.dev/docs)
- [Supabase JS Client](https://supabase.com/docs/reference/javascript/introduction)
- [Supabase Realtime](https://supabase.com/docs/guides/realtime)
- [Tailwind Dark Mode](https://tailwindcss.com/docs/dark-mode)

Good luck with your first full-stack project! 🚀


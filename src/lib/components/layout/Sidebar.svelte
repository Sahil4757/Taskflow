<script lang="ts">
	import { page } from '$app/stores';
	import { enhance } from '$app/forms';
	import { LayoutDashboard, CheckSquare, Folder, Settings, X, LogOut } from 'lucide-svelte';
    
    let { sidebarOpen, closeSidebar } = $props();
    
    let user = $derived($page.data.user);

	// Mock navigation items
	const navItems = [
		{ label: 'Dashboard', href: '/', icon: LayoutDashboard },
		{ label: 'Tasks', href: '/tasks', icon: CheckSquare },
		{ label: 'Projects', href: '/projects', icon: Folder },
		{ label: 'Settings', href: '/settings', icon: Settings }
	];
</script>

<aside
	class="{sidebarOpen ? 'translate-x-0' : '-translate-x-full'} 
    fixed left-0 top-0 z-50 flex h-screen w-64 flex-col overflow-y-hidden bg-white shadow-lg duration-300 ease-linear dark:bg-gray-800 lg:static lg:translate-x-0"
>
	<!-- Sidebar Header -->
	<div class="flex items-center justify-between gap-2 px-6 py-5.5 lg:py-6.5 h-[88px]">
		<a href="/" class="flex items-center gap-2 text-xl font-bold text-indigo-600 dark:text-indigo-400">
			<div class="flex h-8 w-8 items-center justify-center rounded-md bg-indigo-600 text-white">
				TF
			</div>
			TaskFlow
		</a>
        
		<button
			onclick={closeSidebar}
			class="block lg:hidden text-gray-500 hover:text-gray-700 dark:text-gray-400"
		>
			<X size={24} />
		</button>
	</div>

	<div class="no-scrollbar flex flex-col overflow-y-auto duration-300 ease-linear h-full">
		<!-- Sidebar Menu -->
		<nav class="mt-5 px-4 py-4 lg:mt-9 lg:px-6">
			<div>
				<h3 class="mb-4 ml-4 text-sm font-semibold text-gray-500 dark:text-gray-400">MENU</h3>

				<ul class="mb-6 flex flex-col gap-1.5">
					{#each navItems as item}
						<li>
							<a
								href={item.href}
								class="group relative flex items-center gap-2.5 rounded-sm px-4 py-2 font-medium text-gray-500 duration-300 ease-in-out hover:bg-gray-100 hover:text-indigo-600 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white
                                {$page.url.pathname === item.href ? 'bg-gray-100 text-indigo-600 dark:bg-gray-700 dark:text-white' : ''}"
                                onclick={closeSidebar}
							>
								<item.icon size={20} />
								{item.label}
							</a>
						</li>
					{/each}
				</ul>
			</div>
		</nav>
        
        <!-- User Profile Section at bottom -->
        {#if user}
        <div class="mt-auto border-t border-gray-200 p-4 dark:border-gray-700">
             <div class="flex items-center gap-3">
                 <div class="h-10 w-10 rounded-full bg-gray-300 overflow-hidden shrink-0">
                     <!-- Placeholder avatar -->
                     <img src={`https://ui-avatars.com/api/?name=${user.email}`} alt="User" />
                 </div>
                 <div class="flex flex-col overflow-hidden">
                     <span class="text-sm font-medium text-gray-800 dark:text-white truncate">{user.email}</span>
                 </div>
                 <form action="/auth/logout" method="POST" use:enhance class="ml-auto">
                     <button type="submit" class="text-gray-500 hover:text-red-600" aria-label="Logout">
                        <LogOut size={18} />
                     </button>
                 </form>
             </div>
        </div>
        {/if}
	</div>
</aside>

<!-- Overlay for mobile -->
{#if sidebarOpen}
    <!-- svelte-ignore a11y_click_events_have_key_events -->
    <!-- svelte-ignore a11y_no_static_element_interactions -->
    <div 
        class="fixed inset-0 z-40 bg-black/50 lg:hidden backdrop-blur-sm transition-opacity"
        onclick={closeSidebar}
    ></div>
{/if}

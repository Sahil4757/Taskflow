<script lang="ts">
	import { Menu, Bell } from 'lucide-svelte';
    import { page } from '$app/stores';

    let { toggleSidebar } = $props();
    
    let user = $derived($page.data.user);

    // Breadcrumbs logic
    // Simple implementation: split path segments
    let breadcrumbs = $derived($page.url.pathname.split('/').filter(Boolean));
</script>

<header class="sticky top-0 z-40 flex w-full bg-white drop-shadow-sm dark:bg-gray-800">
	<div class="flex flex-grow items-center justify-between px-4 py-4 shadow-2 md:px-6 2xl:px-11">
		<div class="flex items-center gap-2 sm:gap-4 lg:hidden">
			<!-- Hamburger Toggle BTN -->
			<button
				class="z-50 block rounded-sm border border-gray-200 bg-white p-1.5 shadow-sm dark:border-gray-700 dark:bg-gray-800 lg:hidden"
				onclick={toggleSidebar}
			>
				<Menu size={24} />
			</button>
		</div>

		<div class="hidden sm:block">
            <!-- Breadcrumbs -->
            <nav class="flex" aria-label="Breadcrumb">
                <ol class="inline-flex items-center space-x-1 md:space-x-3">
                    <li class="inline-flex items-center">
                    <a href="/" class="inline-flex items-center text-sm font-medium text-gray-700 hover:text-indigo-600 dark:text-gray-400 dark:hover:text-white">
                        Home
                    </a>
                    </li>
                    {#each breadcrumbs as crumb, i}
                        <li>
                        <div class="flex items-center">
                            <span class="mx-2 text-gray-400">/</span>
                            <a href="/{breadcrumbs.slice(0, i + 1).join('/')}" class="ml-1 text-sm font-medium text-gray-700 hover:text-indigo-600 md:ml-2 dark:text-gray-400 dark:hover:text-white capitalize">
                                {crumb}
                            </a>
                        </div>
                        </li>
                    {/each}
                </ol>
            </nav>
		</div>

		<div class="flex items-center gap-3 sm:gap-7">
			<ul class="flex items-center gap-2 sm:gap-4">
				<!-- Notification Menu Area -->
                <li>
                    <button class="relative flex h-8.5 w-8.5 items-center justify-center rounded-full border-[0.5px] border-gray-200 bg-gray-100 hover:text-indigo-600 dark:border-gray-700 dark:bg-gray-700 dark:text-white">
                        <Bell size={20} />
                        <span class="absolute -top-0.5 right-0 z-1 h-2 w-2 rounded-full bg-red-500 inline-block animate-pulse"></span>
                    </button>
                </li>
			</ul>

			<!-- User Area -->
            {#if user}
			<div class="relative">
                <a href="/profile" class="flex items-center gap-4">
                    <span class="hidden text-right lg:block">
                        <span class="block text-sm font-medium text-black dark:text-white">{user.email}</span>
                    </span>
        
                    <span class="h-10 w-10 rounded-full bg-gray-300 overflow-hidden shrink-0">
                         <img src={`https://ui-avatars.com/api/?name=${user.email}`} alt="User" />
                    </span>
                </a>
			</div>
            {/if}
		</div>
	</div>
</header>

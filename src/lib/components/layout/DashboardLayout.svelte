<script lang="ts">
	import Sidebar from './Sidebar.svelte';
	import Header from './Header.svelte';

    let { children } = $props();
	let sidebarOpen = $state(false);

	function toggleSidebar() {
		sidebarOpen = !sidebarOpen;
	}
    
    function closeSidebar() {
        sidebarOpen = false;
    }
</script>

<div class="flex h-screen overflow-hidden bg-gray-50 dark:bg-gray-900">
	<!-- Sidebar -->
	<Sidebar {sidebarOpen} {closeSidebar} />

	<!-- Content area -->
	<div class="relative flex flex-1 flex-col overflow-y-auto overflow-x-hidden">
		<!-- Header -->
		<Header {toggleSidebar} />

		<!-- Main Content -->
		<main class="w-full flex-grow p-6">
			{@render children()}
		</main>
	</div>
</div>

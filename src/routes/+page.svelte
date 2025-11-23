<script lang="ts">
	import DashboardLayout from '$lib/components/layout/DashboardLayout.svelte';
</script>

<DashboardLayout>
	<div class="grid grid-cols-1 gap-4 md:grid-cols-2 md:gap-6 xl:grid-cols-4 2xl:gap-6">
		<div class="rounded-sm border border-gray-200 bg-white px-6 py-6 shadow-md dark:border-gray-700 dark:bg-gray-800">
			<div class="flex h-11.5 w-11.5 items-center justify-center rounded-full bg-indigo-100 dark:bg-indigo-900">
				<!-- Icon -->
			</div>
			<div class="mt-4 flex items-end justify-between">
				<div>
					<h4 class="text-xl font-bold text-black dark:text-white">
						$3.456K
					</h4>
					<span class="text-sm font-medium">Total Revenue</span>
				</div>
			</div>
		</div>
        
        <!-- More dashboard cards... -->
         <div class="rounded-sm border border-gray-200 bg-white px-6 py-6 shadow-md dark:border-gray-700 dark:bg-gray-800">
             <h1 class="text-2xl font-bold mb-4">Welcome to TaskFlow</h1>
             <p>Your new productive workspace.</p>
             <p class="mt-2">Visit <a href="https://svelte.dev/docs/kit" class="text-indigo-600 hover:underline">svelte.dev/docs/kit</a> to read the documentation</p>
         </div>
	</div>
</DashboardLayout>

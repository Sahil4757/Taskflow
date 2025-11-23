import type { LayoutServerLoad } from './$types';
import { redirect } from '@sveltejs/kit';

export const load: LayoutServerLoad = async ({ locals: { safeGetSession }, cookies, url }) => {
	const { session, user } = await safeGetSession();

	// Protect routes
	const publicRoutes = ['/sign-in', '/signup'];
	
	if (!user && !publicRoutes.includes(url.pathname)) {
		redirect(303, '/sign-in');
	}

	if (user && publicRoutes.includes(url.pathname)) {
		redirect(303, '/');
	}

	return {
		session,
		user,
		cookies: cookies.getAll()
	};
};

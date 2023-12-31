import { createRouter, createWebHistory } from 'vue-router';
import HomeView from '../views/HomeView.vue';

const routes = [
	{
		path: '/',
		name: 'home',
		component: HomeView,
	},
	{
		path: '/about',
		name: 'about',
		component: () => import(/* webpackChunkName: "about" */ '../views/AboutView.vue'),
	},
	{
		path: '/add-pet',
		name: 'addPet',
		component: () => import('../views/AddPetView.vue'),
	},
	{
		path: '/search-pet',
		name: 'searchPet',
		component: () => import('../views/GetPetView.vue'),
	},
	{
		path: '/your-pets',
		name: 'yourPets',
		component: () => import('../views/YourPetsView.vue'),
	},
];

const router = createRouter({
	history: createWebHistory(process.env.BASE_URL),
	routes,
});

export default router;

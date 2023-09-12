<template>
	<div class="home">
		<!-- list all pets of the user -->
		<div class="petList">
			<h2>Your pets List</h2>
			<ul>
				<li v-for="pet in pets" :key="pet.id">
					<router-link :to="{ name: 'GetPet', params: { id: pet.id } }">
						{{ pet.name }}
					</router-link>
				</li>
			</ul>
		</div>
	</div>
</template>

<script>
import { ethers } from 'ethers';
import detectEthereumProvider from '@metamask/detect-provider';
import PetIdentity from '../services/PetIdentity.json';

let provider; // Ethereum provider (e.g., MetaMask)
let signer; // Ethereum wallet signer
let contract; // Smart contract instance
const contractAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3';

export default {
	name: 'HomeView',
	data() {
		return {
			petCount: '',
		};
	},
	computed: {},
	methods: {
		async connectWallet() {
			try {
				const ethereum = await detectEthereumProvider();

				if (ethereum) {
					provider = new ethers.providers.Web3Provider(ethereum);
					signer = provider.getSigner();

					// Ensure the user is connected to their wallet
					await ethereum.request({ method: 'eth_requestAccounts' });

					// Initialize the contract with the signer
					contract = new ethers.Contract(contractAddress, PetIdentity.abi, signer);

					// Get and set the pet count (you might want to move this to another method)
					const count = await contract.getPetCount();
					this.petCount = count.toString();
				} else {
					throw new Error(
						'Ethereum provider not detected. Please install MetaMask or another compatible wallet.'
					);
				}
			} catch (error) {
				// Handle errors, e.g., display an error message
				console.error('Error connecting wallet:', error);
			}
		},

		async getPet() {
			try {
				const petId = parseInt(this.petId, 10);

				// Ensure signer is connected and has a valid Ethereum address
				if (!signer || !signer.getAddress()) {
					throw new Error('Please connect to your Ethereum wallet (e.g., MetaMask).');
				}

				// Initialize the contract with the signer
				contract = new ethers.Contract(contractAddress, PetIdentity.abi, signer);

				// Make the contract call to get a pet
				const pet = await contract.getPet(petId);

				this.getpetName = pet.name;
				this.getpetBreed = pet.breed;
				this.getpetAge = pet.age;
				this.getpetHealthRecords = pet.healthRecords;
				this.getpetImage = pet.image;
				this.getpetIsLost = pet.isLost;
				this.getpetIsFound = pet.isFound;

				// Handle success or show a confirmation message
				console.log('Pet retrieved successfully!');
				console.log(pet);

				document.getElementById('petId').style.borderColor = 'black';
			} catch (error) {
				// Handle errors, e.g., display an error message
				console.error('Error getting pet:', error);
				// make the border red
				document.getElementById('petId').style.borderColor = 'red';
			}
		},

		// TODO: create function to list all pets of the user
	},
	async mounted() {
		// Call the connectWallet method to initialize Ethereum connection
		await this.connectWallet();
	},
};
</script>

<template>
	<div class="home">
		<img alt="Vue logo" src="../assets/logo.png" />
		<h1>Digital Pet Identity</h1>
		<p>Create and manage digital identities for pets<br /></p>
		<h3 class="main-subheading">Total pets in the chain: {{ petCount }}</h3>
	</div>

	<footer>
		<p>
			2023 - Faculty of Informatics Pula -
			<a href="https://github.com/mathamer" target="_blank">mathamer</a>
		</p>
	</footer>
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
				} else {
					throw new Error(
						'Ethereum provider not detected. Please install MetaMask or another compatible wallet.'
					);
				}
			} catch (error) {
				console.error('Error connecting wallet:', error);
			}
		},

		async getPetCount() {
			try {
				if (!signer || !signer.getAddress()) {
					throw new Error('Please connect to your Ethereum wallet (e.g., MetaMask).');
				}
				contract = new ethers.Contract(contractAddress, PetIdentity.abi, signer);

				const count = await contract.getPetCount();

				// Set the pet count in the data
				this.petCount = count.toString();
			} catch (error) {
				console.error('Error getting pet count:', error);
			}
		},

		async getPet() {
			try {
				const petId = parseInt(this.petId, 10);

				if (!signer || !signer.getAddress()) {
					throw new Error('Please connect to your Ethereum wallet (e.g., MetaMask).');
				}

				contract = new ethers.Contract(contractAddress, PetIdentity.abi, signer);

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

				document.getElementById('petId').style.borderColor = 'gray';
			} catch (error) {
				console.error('Error getting pet:', error);
				document.getElementById('petId').style.borderColor = 'red';
			}
		},
	},
	async mounted() {
		// Call the connectWallet method to initialize Ethereum connection
		await this.connectWallet();
		await this.getPetCount();
	},
};
</script>

<style>
.wrapper {
	min-height: 100vh;
	position: relative;
}

.content {
	padding-bottom: 50px; /* Height of the footer */
}

footer {
	position: fixed;
	bottom: 0;
	width: 100%;
	height: 50px;
	background-color: #f5f5f5;
	text-align: center;
	padding-top: 15px;
}
</style>

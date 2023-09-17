<template>
	<div id="app">
		<div class="getPet">
			<label for="petId">Pet ID: </label>
			<input
				type="text"
				id="petId"
				name="petId"
				v-model="petId"
				placeholder="Enter desired pet ID"
			/><br /><br />
			<button class="button" @click="getPet()">Search</button>
			<p id="error"></p>
		</div>

		<div class="petInfo">
			<h2>Pet Info</h2>
			<div class="row">
				<div class="column" style="text-align: left">
					<!-- First column content goes here -->
					<div v-if="getpetImage">
						<label for="petImage">Image: </label>
						<!-- <a :href="getpetImage" target="_blank">Link</a><br /><br /> -->
						<img :src="getpetImage" alt="Your Image" height="280" />
					</div>
				</div>
				<div class="column" style="text-align: left">
					<!-- Second column content goes here -->
					<label for="petName">Name: </label>
					<input type="text" id="getpetName" name="getpetName" v-model="getpetName" /><br /><br />
					<label for="petBreed">Breed: </label>
					<input type="text" id="petBreed" name="petBreed" v-model="getpetBreed" /><br /><br />
					<label for="petAge">Date of birth: </label>
					<input type="text" id="petAge" name="petAge" v-model="getpetAge" /><br /><br />
					<label for="petHealthRecords">Health Records: </label>
					<input
						type="text"
						id="petHealthRecords"
						name="petHealthRecords"
						v-model="getpetHealthRecords"
					/>
				</div>
				<div class="column">
					<!-- Third column content goes here -->
					<label for="petIsLost">Is Lost: </label>
					<input type="text" id="petIsLost" name="petIsLost" v-model="getpetIsLost" /><br /><br />
					<label for="petIsFound">Is Found: </label>
					<input
						type="text"
						id="petIsFound"
						name="petIsFound"
						v-model="getpetIsFound"
					/><br /><br />
				</div>
			</div>
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
	name: 'App',
	props: {
		msg: String,
	},
	data() {
		return {
			petCount: '',
			petId: '',
			petName: '',
			petBreed: '',
			petAge: '',
			petHealthRecords: '',
			petImage: '',
			errorMessage: '',

			getpetName: '',
			getpetBreed: '',
			getpetAge: '',
			getpetHealthRecords: '',
			getpetImage: '',
			getpetIsLost: '',
			getpetIsFound: '',
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

				document.getElementById('petId').style.borderColor = '';
				document.getElementById('error').innerHTML = '';
			} catch (error) {
				// Handle errors, e.g., display an error message
				console.error('Error getting pet:', error);

				document.getElementById('petId').style.borderColor = 'red';
				document.getElementById('error').innerHTML = 'Pet ID not found!';
			}
		},
	},
	async mounted() {
		// Call the connectWallet method to initialize Ethereum connection
		await this.connectWallet();
	},
};
</script>

<style>
.balance {
	display: block;
	margin: 10px;
}

#app {
	font-family: Avenir, Helvetica, Arial, sans-serif;
	-webkit-font-smoothing: antialiased;
	-moz-osx-font-smoothing: grayscale;
	text-align: center;
	color: #2c3e50;
	margin-top: 60px;
}

.row {
	display: flex;
}

.column {
	flex: 1;
	margin: 0 10%;
}

#error {
	color: red;
}
</style>

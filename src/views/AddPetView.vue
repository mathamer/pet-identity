<template>
	<div id="app">
		<div class="main-head">
			<h3 class="main-subheading">Total pets in the chain: {{ petCount }} +1</h3>
			<!-- TODO: animate this number when a new pet is added -->
		</div>

		<div class="addPet">
			<h2>Add a pet</h2>
			<label for="name">Name*: </label>
			<input type="text" id="petName" name="petName" v-model="petName" /><br /><br />
			<label for="breed">Breed*: </label>
			<input type="text" id="petBreed" name="petBreed" v-model="petBreed" /><br /><br />
			<label for="age">Date of birth*: </label>
			<input
				type="text"
				id="petAge"
				name="petAge"
				v-model="petAge"
				placeholder="Enter full date or just year"
			/><br /><br />
			<label for="healthRecords">Health Records: </label>
			<input
				type="text"
				id="petHealthRecords"
				name="petHealthRecords"
				v-model="petHealthRecords"
			/><br /><br />
			<label for="image">Image: </label>
			<input
				type="text"
				id="petImage"
				name="petImage"
				v-model="petImage"
				placeholder="Url link to image"
			/><br /><br />
			<button class="button" @click="addPet()">Add Pet</button>
			<p id="error"></p>
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

		async addPet() {
			try {
				const petName = this.petName;
				const petBreed = this.petBreed;
				const petAge = parseInt(this.petAge, 10);
				const healthRecords = this.petHealthRecords;
				const image = this.petImage;

				// Ensure signer is connected and has a valid Ethereum address
				if (!signer || !signer.getAddress()) {
					throw new Error('Please connect to your Ethereum wallet (e.g., MetaMask).');
				}

				// Initialize the contract with the signer
				contract = new ethers.Contract(contractAddress, PetIdentity.abi, signer);

				// Make the contract call to add a pet
				const tx = await contract.addPet(petName, petBreed, petAge, healthRecords, image);
				await tx.wait();

				// Handle success or show a confirmation message
				console.log('Pet added successfully!');
				document.getElementById('error').innerHTML = '';
				alert('Pet added successfully!');
			} catch (error) {
				// Handle errors, e.g., display an error message
				console.error('Error adding pet:', error);
				// if petName, petBreed and petAge is empty make text field red
				if (this.petName == '' || this.petBreed == '' || this.petAge == '') {
					document.getElementById('petName').style.borderColor = 'red';
					document.getElementById('petBreed').style.borderColor = 'red';
					document.getElementById('petAge').style.borderColor = 'red';
					document.getElementById('error').innerHTML = 'Please fill out necessary fields';
					document.getElementById('error').style.color = 'red';
				}
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
</style>

<template>
	<div class="home">
		<!-- list all pets of the user -->
		<div class="petList" v-if="pets.length > 0">
			<h2>Your pets List</h2>
			<ul>
				<table style="width: 100%">
					<tr>
						<!-- <th>PetID</th> -->
						<th>Image</th>
						<th>Name</th>
						<th>Breed</th>
						<th>Dob</th>
						<th>Health Records</th>
						<th>Is Lost</th>
						<th>Is Found</th>
						<th></th>
						<th></th>
					</tr>
					<tr v-for="pet in pets" :key="pet.id">
						<!-- <td>{{ pet.id }}</td> -->
						<!-- TODO: why is petID undefined? -->
						<!-- <td>{{ pet.image }}</td> -->
						<td>
							<img :src="pet.image" alt="Your Image" height="100" />
						</td>
						<td>{{ pet.name }}</td>
						<td>{{ pet.breed }}</td>
						<td>{{ pet.age }}</td>
						<td>{{ pet.healthRecords }}</td>
						<td>
							<input type="checkbox" id="isLost" name="isLost" v-model="pet.isLost" disabled />
							<button class="button" @click="reportLost(pet.id)">Report</button>
						</td>
						<td>
							<input type="checkbox" id="isFound" name="isFound" v-model="pet.isFound" disabled />
							<button class="button" @click="reportFound(pet.id)">Report</button>
						</td>
						<td>
							<!-- <button class="button" @click="transferOwnership(pet.id, pet.newOwner)">Transfer Ownership</button> -->
							<!-- open small modal to enter new owner address on button click -->
							<button class="button" @click="transfer(pet.id)">Transfer Ownership</button>
						</td>
						<td><button @click="editPet(pet)">Edit</button></td>
					</tr>
				</table>
			</ul>
		</div>
		<div v-if="pets.length === 0">
			<h2>You haven't added any pets yet!</h2>
		</div>
	</div>

	<!-- Use the modal component -->
	<edit-pet-modal
		:show-modal="showEditModal"
		:pet-data="selectedPet"
		@save="savePetChanges"
		@close="showEditModal = false"
	></edit-pet-modal>

	<transfer-ownership-modal
		:show-modal="showTransferModal"
		:pet-id="petId"
		@save="savePetChanges"
		@close="showTransferModal = false"
	></transfer-ownership-modal>
</template>

<script>
import EditPetModal from '../components/EditPetModal.vue';
import TransferOwnershipModal from '../components/TransferOwnershipModal.vue';

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
			pets: [],
			showEditModal: false,
			showTransferModal: false,
			selectedPet: null,
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

					// Make the contract call to all pets of the user
					const pets = await contract.listAllOwnerPets(signer.getAddress());

					this.pets = pets;

					console.log(pets);
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
		async reportLost(petId) {
			try {
				if (!signer || !signer.getAddress()) {
					throw new Error('Please connect to your Ethereum wallet (e.g., MetaMask).');
				}

				contract = new ethers.Contract(contractAddress, PetIdentity.abi, signer);

				const reportLost = await contract.reportLost(petId);

				console.log(reportLost);
			} catch (error) {
				console.error('Error Reporting lost pet:', error);
			}
		},

		async reportFound(petId) {
			try {
				if (!signer || !signer.getAddress()) {
					throw new Error('Please connect to your Ethereum wallet (e.g., MetaMask).');
				}

				contract = new ethers.Contract(contractAddress, PetIdentity.abi, signer);

				const reportFound = await contract.reportFound(petId);

				console.log(reportFound);
			} catch (error) {
				console.error('Error Reporting found:', error);
			}
		},

		async transferOwnership(petId, newOwner) {
			try {
				if (!signer || !signer.getAddress()) {
					throw new Error('Please connect to your Ethereum wallet (e.g., MetaMask).');
				}
				contract = new ethers.Contract(contractAddress, PetIdentity.abi, signer);

				// Make the contract call to transfer ownership of the pet
				const transferOwnership = await contract.transferOwnership(petId, newOwner);

				console.log(transferOwnership);
			} catch (error) {
				console.error('Error transfering ownership:', error);
			}
		},

		editPet(pet) {
			this.selectedPet = pet;
			this.showEditModal = true;
		},

		async savePetChanges(petData) {
			try {
				console.log(petData);
				if (!signer || !signer.getAddress()) {
					throw new Error('Please connect to your Ethereum wallet (e.g., MetaMask).');
				}

				contract = new ethers.Contract(contractAddress, PetIdentity.abi, signer);

				// Make the contract call to save changes to the pet's data
				const tx = await contract.updatePetInformation(
					petData.petId,
					petData.editedPetName,
					petData.editedPetBreed,
					petData.editedPetAge,
					petData.editedPetHealthRecords,
					petData.editedPetImage
				);
				await tx.wait();

				console.log('Pet edited successfully!');
				alert('Pet edited successfully!');
			} catch (error) {
				console.error('Error editing pet:', error);
			}
		},
		transfer(petId) {
			this.petId = petId;
			this.showTransferModal = true;
		},
	},
	components: {
		EditPetModal, // Register the modal component
		TransferOwnershipModal,
	},
	async mounted() {
		// Call the connectWallet method to initialize Ethereum connection
		await this.connectWallet();
	},
};
</script>

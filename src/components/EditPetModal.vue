<!-- EditPetModal.vue -->
<template>
	<div class="modal-overlay" v-if="showModal" @click="closeModalOutside">
		<div class="modal-content">
			<button class="close-button" @click="closeModal">X</button>
			<h2>Edit Pet Information</h2>
			<label for="name">Chosen pet: </label>
			<label for="name">{{ petData.name }}</label
			><br /><br />
			<input v-model="editedPetName" placeholder="Name" /><br /><br />
			<input v-model="editedPetBreed" placeholder="Breed" /><br /><br />
			<input v-model="editedPetAge" placeholder="Age" /><br /><br />
			<input v-model="editedPetHealthRecords" placeholder="Health Records" /><br /><br />
			<input v-model="editedPetImage" placeholder="Image" /><br /><br />
			<button @click="saveChanges">Save Changes</button>
		</div>
	</div>
</template>

<script>
export default {
	name: 'EditPetModal',
	props: {
		showModal: Boolean,
		petData: Object, // Data of the pet being edited
	},
	data() {
		return {
			editedPetName: '',
			editedPetBreed: '',
			editedPetAge: '',
			editedPetHealthRecords: '',
			editedPetImage: '',
		};
	},
	methods: {
		saveChanges() {
			// Call a method to save changes to the pet's data
			// Emit an event to notify the parent component that changes were saved
			this.$emit('save', { petId: this.petData.id, editedPetName: this.editedPetName });
			this.closeModal();

			// if name, breed, age are empty, keep the old values
			if (this.editedPetName === '') {
				this.editedPetName = this.petData.name;
			}
			if (this.editedPetBreed === '') {
				this.editedPetBreed = this.petData.breed;
			}
			if (this.editedPetAge === '') {
				this.editedPetAge = this.petData.age;
			}
			if (this.editedPetHealthRecords === '') {
				this.editedPetHealthRecords = this.petData.healthRecords;
			}
			if (this.editedPetImage === '') {
				this.editedPetImage = this.petData.image;
			}

			// If nothing has changed, do not update
			if (
				this.editedPetName === this.petData.name &&
				this.editedPetBreed === this.petData.breed &&
				this.editedPetAge === this.petData.age &&
				this.editedPetHealthRecords === this.petData.healthRecords &&
				this.editedPetImage === this.petData.image
			) {
				alert('No changes were made.');
				return;
			}
		},

		closeModal() {
			this.$emit('close');
		},

		closeModalOutside(event) {
			if (event.target.closest('.modal-content') === null) {
				this.closeModal(); // Close the modal when clicking outside the modal content
			}
		},
	},
};
</script>

<style scoped>
.modal-overlay {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.5); /* Semi-transparent overlay */
	display: flex;
	justify-content: center;
	align-items: center;
}

.modal-content {
	background-color: white;
	padding: 20px;
	border-radius: 5px;
}

.close-button {
	position: absolute;
	top: 10px;
	right: 10px;
	cursor: pointer;
}
</style>

<!-- TransferOwnershipModal.vue -->
<template>
	<div class="modal-overlay" v-if="showModal" @click="closeModalOutside">
		<div class="modal-content">
			<button class="close-button" @click="closeModal">X</button>
			<h2>Transfer Ownership</h2>
			<label for="newOwner">New Owner address: </label>
			<input type="text" id="newOwner" name="newOwner" v-model="newOwner" /><br /><br />
			<button class="button" @click="transferOwnership()">Transfer Ownership</button>
		</div>
	</div>
</template>

<script>
export default {
	name: 'TransferOwnershipModal',
	props: {
		showModal: Boolean,
		petId: String,
	},
	data() {
		return {};
	},
	methods: {
		transferOwnership() {
			// Call a method to transfer ownership of the pet
			// Emit an event to notify the parent component that changes were saved
			this.$emit('save', { petId: this.petId, newOwner: this.newOwner });
			this.closeModal();
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
/* Styles for the modal overlay */
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

/* Styles for the modal content */
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

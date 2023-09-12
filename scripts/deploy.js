const hre = require('hardhat');

async function deploy() {
	const PetIdentity = await hre.ethers.getContractFactory('PetIdentity');
	const petIdentity = await PetIdentity.deploy();
	await petIdentity.deployed();

	console.log('PetIdentity contract deployed to:', petIdentity.address);
}

async function main() {
	try {
		await deploy();
		process.exit(0);
	} catch (e) {
		console.error(e);
		process.exit(0);
	}
}

main();

//$ npx hardhat run scripts/deploy.js --network localhost

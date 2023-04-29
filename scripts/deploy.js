async function main() {
	const [deployer] = await ethers.getSigners();

	console.log("Deploying contracts with the account:", deployer.address);

	console.log("Account balance:", (await deployer.getBalance()).toString());

	const L00kinPFPMinter = await ethers.getContractFactory("L00kinPFPMinter");
	const l00kinPFPMinterContract = await L00kinPFPMinter.deploy('0x5FbDB2315678afecb367f032d93F642f64180aa3');
	console.log("L00kinPFPMinter contract address:", l00kinPFPMinterContract.address);
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});
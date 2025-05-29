const hre = require("hardhat");

async function main() {
  // Replace with actual deployed ERC20 token contract if needed
  const paymentTokenAddress = "0xYourERC20TokenAddressHere";

  const TimeMint = await hre.ethers.getContractFactory("TimeMint");
  const timeMint = await TimeMint.deploy(paymentTokenAddress);

  await timeMint.deployed();
  console.log("TimeMint contract deployed to:", timeMint.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

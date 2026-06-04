const hre = require("hardhat");
const fs = require("fs");
const path = require("path");

async function main() {
  console.log("Iniciando deploy...");
  const contract = await hre.ethers.deployContract("LitVMFliperama");
  await contract.waitForDeployment();
  const address = await contract.getAddress();
  
  console.log("Endereco:", address);

  const indexPath = path.join(__dirname, "..", "index.html");
  if (fs.existsSync(indexPath)) {
    let content = fs.readFileSync(indexPath, "utf8");
    content = content.replace(/const CONTRACT_ADDRESS = "[^"]*";/, `const CONTRACT_ADDRESS = "${address}";`);
    fs.writeFileSync(indexPath, content);
    console.log("Endereco injetado no index.html!");
  }
}

main().catch((error) => { console.error(error); process.exit(1); });

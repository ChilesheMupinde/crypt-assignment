const Crowdfunding = artifacts.require("./Crowdfunding.sol");

module.exports = function(deployer) {
  // Command Truffle to deploy the Smart Contract
  deployer.deploy(Crowdfunding);
};
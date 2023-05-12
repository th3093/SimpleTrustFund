var MyContract = artifacts.require("TrustFund");

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(MyContract);
};
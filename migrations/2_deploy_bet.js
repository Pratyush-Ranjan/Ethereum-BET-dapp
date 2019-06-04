var bet = artifacts.require("./bet.sol");
module.exports = function(deployer) {
  deployer.deploy(web3.toWei(0.1, 'ether'), 20, {gas: 3000000});
};

# SimpleTrustFund

## Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Usage](#usage)
- [Deployment](#deployment)

## About <a name = "about"></a>

The purpose of this project was creating a simple implementation of a fixed-time asset-locking smart contract. The use cases are e.g. parents saving for college tuition fees of their children.<br>
Live running, [verified](https://sepolia.etherscan.io/address/0x59cf5872a7bc78d6aafde328f47dfadde7cf5cfb#code) demo is available on Sepolia-Testnet at 0x59cf5872A7Bc78d6AAfdE328f47DFaDdE7Cf5cFB <br><br>
   

## Getting Started <a name = "getting_started"></a>

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See [deployment](#deployment) for notes on how to deploy the project on a live system.<br><br>


### Prerequisites

I recommend using either [RemixIDE](https://remix.ethereum.org/) or [VSCode](https://code.visualstudio.com/) as IDE for this (and mostly any) Smart Contract projects. <br>
To simplify the process, RemixIDE is faster way to run this project. Either copy the [SimpleTrustFund.sol](./contracts/TrustFund.sol) or clone this repo inside the browser-based IDE of Remix.<br><br>


### Installing

By using Remix, there is no need of installing anything.

For setting up the contract and deploying it, you need to:<br>
            1. compile the contract<br>
            2. deploy the contract on your chain of choice

For more information on these steps visit the [Documentation](https://remix-ide.readthedocs.io/en/latest/index.html) of Remix.<br><br>



## Usage <a name = "usage"></a>

Following the different functions of the contract will be explained in detail.<br><br>
The first function we look at is addBeneficiary:
```
function addBeneficiary(address _ben, uint256 _timeToPayOut) external payable
```
The inputs of the contract call are the address of the person which can withdraw later on (namely beneficiary) and the time to elapse till locking ends. The function is payable, so Ether can be transfered via msg.value to the contract.<br><br>
The second function we look at is safeDeposit:

```
function safeDeposit(address _ben) external payable
```
To call this function, you need to be known as a fund donor of this particular beneficiary by the contract. E.g. you added the funding address or already deposited via forceDeposit.<br><br>
Next we head over to forceDeposit:
```
function forceDeposit(address _ben) external payable
```
Basically it is the same function as as safeDeposit, but with fewer condition checks. So anyone can deposit to a specific, already added funding address. Think of it as enabling pool saving. Be careful and double check the address when calling!<br><br>
We going straight to the next one:
```
function withdraw() external
```
Withdraw has to be called by the beneficiary(!) and checks whether there is withdrawable value available. Saying that, the value has to be greater than zero, the locking period has to be ended and, of course, there wasn't a withdrawal of the funds yet.<br><br>
The last two functions are declared as view. They are for getting information on:
```
function remainingTime() external view returns (uint256)
```
The remaining time till the locking period ends, which has to be called by the beneficiary, and<br><br>
```
function getBen(address _ben) external view returns (uint256, uint256, bool, address[])
```
Information on a specific benificiary _ben, showing as the total value, the end of locking period, whether its already withdrawn or not and a array of all donors to this address.
This function was intended for testing purposes and is not in final form. At the moment, anyone with the address of _ben can see its underlying stats, which will be conditioned to only know donors in future updates.
<br><br>

## Deployment <a name = "deployment"></a>
To deploy on Sepolia-Testnet, make sure to have enough SepETH (otherwise use a [Faucet](https://sepoliafaucet.com/)). Simple deployment requires a MetaMask-Wallet. If you want to use WalletConnect, please refer to their [documentation](https://docs.walletconnect.com/2.0/).<br>
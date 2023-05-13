# SimpleTrustFund

The project contains a simple smart contract for time-based fund locking.
Any caller can create a funding for one or more specific addresses to be withdrawn after a fixed time.
It is possible to pool funds from different sources to a single beneficiary.

Functions include:

 - addBeneficiary
    function addBeneficiary(address _ben, uint256 _timeToPayOut) external payable <br>
    -> Add new beneficiary address with locked time duration

 - safeDeposit
    function safeDeposit(address _ben) external payable <br>
    -> Deposit funds as known sender to beneficiary address

 - forceDeposit
    function forceDeposit(address _ben) external payable <br>
    -> Deposit funds as new sender to beneficiary address (double check the address!)

 - withdraw
    function withdraw() external <br>
    -> After locking time elapsed, beneficiary address can withdraw

 - remainingTime
    function remainingTime() external view returns (uint256) <br>
    -> Beneficiary address can check remaining time

 - getBen
    function getBen(address _ben) external view returns (uint256, uint256, bool, address[]) <br>
    -> See amount and funding addresses of a beneficiary

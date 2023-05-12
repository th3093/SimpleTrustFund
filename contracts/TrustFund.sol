// SPDX-License-Identifier: UNLICENSED
pragma solidity <0.9.0;


contract TrustFund{

    struct Beneficiary{
        uint value;
        uint payOutDate;
        bool paid;
    }

    mapping(address =>  Beneficiary) public beneficiaries;
    address public admin;

    constructor (){
        admin = msg.sender;
    }

    modifier isAdmin() {
        require(admin == msg.sender, "Action not allowed. Permission: Only Admin");
        _;
    }

    modifier isBen(address _ben) {
        require(beneficiaries[_ben].value > 0, "Please add beneficiary address first");
        _;
    }

    modifier isNotBen(address _ben){
        require(beneficiaries[_ben].value == 0, "Beneficiary already created");
        _;
    }

    modifier isWithdrawable(address _ben){
        require(beneficiaries[_ben].value > 0, "Nothing to Withdraw. Please add funds first");
        require(beneficiaries[_ben].payOutDate < block.timestamp, "Not withdrawable. Wait till fund locking period ends");
        require(beneficiaries[_ben].paid == false, "Already withdrawn funds");
        _;
    }

    event BeneficiaryCreated(
        address indexed _ben,
        uint _payOutDate,
        uint _value
    );

    event Deposit(
        address indexed _ben,
        uint _value
    );

    event Withdraw(
        address indexed _ben,
        uint _value
    );

    event Remaining(
        address indexed _ben,
        bool isTimeRemaining,
        uint actStamp,
        uint initialStamp
    );

    // beneficiaries[_ben] = Beneficiary(msg.value, _timeToPayOut * 31556952 + block.timestamp, false);
    function addBeneficiary(address _ben, uint _timeToPayOut) external payable isAdmin() isNotBen(_ben) {
        beneficiaries[_ben] = Beneficiary(msg.value, _timeToPayOut * 20 + block.timestamp, false);
        emit BeneficiaryCreated(_ben, _timeToPayOut, msg.value);
    }

    function deposit(address _ben) external payable isAdmin() isBen(_ben) {
        beneficiaries[_ben].value += msg.value;
        emit Deposit(_ben, msg.value);
    }

    function withdraw() external isWithdrawable(msg.sender){
        Beneficiary storage ben = beneficiaries[msg.sender];
        ben.paid = true;
        payable(msg.sender).transfer(ben.value);
        emit Withdraw(msg.sender, ben.value);
        delete beneficiaries[msg.sender];
    }
  
    function remainingTime() external view returns(uint){
        //emit Remaining(msg.sender, beneficiaries[msg.sender].payOutDate > block.timestamp ? true:false, block.timestamp, beneficiaries[msg.sender].payOutDate);
        require(beneficiaries[msg.sender].payOutDate > block.timestamp, "Funds are already unlocked and can be claimed.");
        return beneficiaries[msg.sender].payOutDate - block.timestamp;
    }

}
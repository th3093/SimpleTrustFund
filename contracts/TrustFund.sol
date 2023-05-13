// SPDX-License-Identifier: UNLICENSED
pragma solidity <0.9.0;


contract TrustFund{

    struct Beneficiary{
        uint value;
        uint payOutDate;
        bool paid;
        address[] spenders;
    }


    mapping(address => bytes32) beneficiaryIDs;
    mapping(bytes32 => Beneficiary) beneficiaries;
    mapping(address => mapping(bytes32 => bool)) spenderVal;


    modifier isSpender(address _ben){
        require(spenderVal[msg.sender][beneficiaryIDs[_ben]], "Origin of call not initial spender address");
        _;
    }

    modifier isValidValue(){
        require(msg.value > 0, "Please send some funds");
        _;
    }

    modifier isBen(address _ben) {
        require(beneficiaries[beneficiaryIDs[_ben]].value > 0, "Please add beneficiary address first");
        _;
    }

    modifier isNotBen(address _ben){
        require(beneficiaries[beneficiaryIDs[_ben]].value == 0, "Beneficiary already created. Check etherscan for more information.");
        _;
    }

    modifier isWithdrawable(address _ben){
        require(beneficiaries[beneficiaryIDs[_ben]].value > 0, "Nothing to Withdraw. Please add funds first");
        require(beneficiaries[beneficiaryIDs[_ben]].payOutDate < block.timestamp, "Not withdrawable. Wait till fund locking period ends");
        require(beneficiaries[beneficiaryIDs[_ben]].paid == false, "Already withdrawn funds");
        _;
    }

    event BeneficiaryCreated(
        address indexed _spender,
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
    function addBeneficiary(address _ben, uint _timeToPayOut) external payable isValidValue() isNotBen(_ben) {
        beneficiaryIDs[_ben] = keccak256(abi.encodePacked(_ben));
        beneficiaries[beneficiaryIDs[_ben]] = Beneficiary(msg.value, _timeToPayOut * 20 + block.timestamp, false, new address[](0));
        beneficiaries[beneficiaryIDs[_ben]].spenders.push(msg.sender);
        spenderVal[msg.sender][beneficiaryIDs[_ben]] = true;
        emit BeneficiaryCreated(msg.sender, _ben, _timeToPayOut, msg.value);
    }

    function safeDeposit(address _ben) external payable isSpender(_ben) isBen(_ben) {
        beneficiaries[beneficiaryIDs[_ben]].value += msg.value;
        emit Deposit(_ben, msg.value);
    }

    function forceDeposit(address _ben) external payable isBen(_ben) {
        beneficiaries[beneficiaryIDs[_ben]].value += msg.value;
        beneficiaries[beneficiaryIDs[_ben]].spenders.push(msg.sender);
        spenderVal[msg.sender][beneficiaryIDs[_ben]] = true;
        emit Deposit(_ben, msg.value);
    }

    function withdraw() external isWithdrawable(msg.sender){
        Beneficiary storage ben = beneficiaries[beneficiaryIDs[msg.sender]];
        ben.paid = true;
        payable(msg.sender).transfer(ben.value);
        emit Withdraw(msg.sender, ben.value);
        delete beneficiaries[beneficiaryIDs[msg.sender]];
        delete beneficiaryIDs[msg.sender];
    }
  
    function remainingTime() external view returns(uint){
        require(beneficiaries[beneficiaryIDs[msg.sender]].payOutDate > block.timestamp, "Funds are already unlocked and can be claimed.");
        return beneficiaries[beneficiaryIDs[msg.sender]].payOutDate - block.timestamp;
    }

    function getBen(address _ben) external view returns(uint, uint, bool, address[] memory){
        return (
            beneficiaries[beneficiaryIDs[_ben]].value, 
            beneficiaries[beneficiaryIDs[_ben]].payOutDate, 
            beneficiaries[beneficiaryIDs[_ben]].paid, 
            beneficiaries[beneficiaryIDs[_ben]].spenders
            );
    }

}
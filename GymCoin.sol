// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract GymCoin {
   
    struct User {
        bytes32 userID; // Unique ID for each user
        bytes32[] deviceID; // Unique ID for each device
        // character;
        uint balance; // Balance of GymCoins
        // transaction;
        bytes32[] contractID; // List of contracts signed
    }

    mapping(address => User) public Users;
    bytes32 [] userIDs;

    constructor(bytes32 memory userid, bytes32[] memory deviceIDs, uint memory balance, bytes32[] memory contractIDs) {
        Users.push(User({
            userID: userid,
            deviceID: deviceIDs,
            balance: balance,
            contractID: contractIDs
            }));
        userIDs.push(userid);
    }


    // function exchange(bytes32 user2, uint amount) public {
    //     User storage sender = Users[msg.sender];
    //     // require(!sender.voted, "Already voted.");
    //     sender.balance -= amount; // Could be negative
    //     userIDs
    // }

    function signContract(bytes32 userID, bytes32 contractID) public {

    }

    function cancelContract(bytes32 userID, bytes32 contractID) public {

    }
    
}


contract token { 
    mapping (uint => mapping (address => uint)) coinBalanceOf;
    event CoinTransfer(uint coinType, address sender, address receiver, uint amount);

    /* Initializes contract with initial supply tokens to the creator of the contract */
    function token(uint numCoinTypes, uint supply) {
        for (uint k=0; k<numCoinTypes; ++k) {
        coinBalanceOf[k][msg.sender] = supply;
        }
    }

    /* Very simple trade function */
    function sendCoin(uint coinType, address receiver, uint amount) returns(bool sufficient) {
        if (coinBalanceOf[coinType][msg.sender] < amount) return false;

        coinBalanceOf[coinType][msg.sender] -= amount;
        coinBalanceOf[coinType][receiver] += amount;

        CoinTransfer(coinType, msg.sender, receiver, amount);

        return true;
    }
}
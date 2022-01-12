// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract GymCoin {

    struct exercise {
        bytes32 userID;   // short name (up to 32 bytes)
        uint deviceID;    // the device ID for user
        uint gymcoin;    //gym coin amount
    }

    struct User {
        bytes32 userID; // Unique ID for each user
        uint [] deviceIDs; // Unique ID for each device
        uint balance; // Balance of GymCoins
        uint contractID; // List of contracts signed
    }

    mapping(address => User) public Users;      //TODO: after mapping address to User, what does Users do?

    function add_user(bytes32 userid, uint [] memory deviceIDs, uint balance, uint contractIDs) public {
        User storage sender = Users[msg.sender];
        sender.userID = userid;
        sender.deviceIDs = deviceIDs;
        sender.balance = balance;
        sender.contractID = contractIDs;
    }


    function add_exercise(bytes32 userid, uint deviceid, uint heartrate1, uint workout_type1, uint workout_time1, uint calories1) public {
        User storage sender = Users[msg.sender];
        // require(deviceid in sender.deviceIDs);
        sender.balance += reward(heartrate1,workout_type1,workout_time1,calories1);
    }

    function reward(uint heartrate1, uint workout_type1, uint workout_time1, uint calories1) public view returns(uint earned){
        //The formula will divide by the heartrate to make it fair to those people who do weight training
        earned = calories1 / heartrate1 * workout_time1 / 2000;
    }

    function exchange(address user2, uint amount) public {
        User storage sender = Users[msg.sender];
        require(sender.balance >= amount);
        
        sender.balance -= amount; // Could be negative
        Users[user2].balance += amount;
    }

    function signContract(bytes32 userID, bytes32 contractID) public {

    }

    function cancelContract(bytes32 userID, bytes32 contractID) public {

    }
    
}


// contract token { 
//     mapping (uint => mapping (address => uint)) coinBalanceOf;

//     event CoinTransfer(uint coinType, address sender, address receiver, uint amount);

//     /* Initializes contract with initial supply tokens to the creator of the contract */
//     function tokenSupply(uint numCoinTypes, uint supply) public { //
//         for (uint k=0; k<numCoinTypes; ++k) {
//             coinBalanceOf[k][msg.sender] = supply;
//         }
//     }

//     /* Very simple trade function */
//     function sendCoin(uint coinType, address receiver, uint amount) public returns (bool sufficient) {
//         if (coinBalanceOf[coinType][msg.sender] < amount) return false;

//         coinBalanceOf[coinType][msg.sender] -= amount;
//         coinBalanceOf[coinType][receiver] += amount;

//         emit CoinTransfer(coinType, msg.sender, receiver, amount);

//         return true;
//     }
// }

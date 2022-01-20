// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// import "./Datetime.sol";
// import moment from "moment";


contract GymCoin {

    struct Exercise {
        bytes32 userID;   // Short name (up to 32 bytes)
        uint deviceID;    // The device ID for user
        uint gymcoin;    // GymCoin amount
    }
    
    struct User {
        bytes32 userID; // Unique ID for each user
        uint [] deviceIDs; // Unique ID for each device
        uint balance; // Balance of GymCoins
        uint balance_reset; // Keep track of total balance at the previous round
        uint contractID; // List of contracts signed
        bool registered; // true means one has already registered and cannot add_user again
        uint timeSigned; // The baseline time of signing one Contract
        // DateTime time;
    }

    struct Post { // Could also do Like System
        // uint postID;
        bytes32 userID; // Unique ID for each user
        string context;
        uint time;
        // uint numberOfLikes;
    }

    mapping(address => User) public Users;
    Post[] public Posts;

    function Register(bytes32 userid, uint [] memory deviceIDs) public {
        User storage sender = Users[msg.sender];
        require(!sender.registered, "You have already registered");

        sender.userID = userid;
        sender.deviceIDs = deviceIDs;
        sender.balance = 0;
        sender.balance_reset = 0;
        sender.contractID = 0;
        sender.registered = true;
    }

    function add_device(uint newDeviceID) public {
        User storage sender = Users[msg.sender];
        require(sender.registered == true, "You have not registered.");

        sender.deviceIDs.push(newDeviceID);
    }

    function add_exercise(bytes32 userid, uint deviceid, uint heartrate1, uint workout_time1, uint calories1) public {
        User storage sender = Users[msg.sender];
        require(sender.registered == true, "You have not registered.");
        require(sender.userID == userid, "Wrong User ID");

        // Check if the device is recorded
        bool Contain = false;
        for (uint i=0; i < sender.deviceIDs.length; i++) {
            if (deviceid == sender.deviceIDs[i]) { Contain = true; }
        }
        require(Contain == true, "Must use the correct device");

        sender.balance += reward(heartrate1, workout_time1, calories1);
    }

    function reward(uint heartrate1, uint workout_time1, uint calories1) private pure returns(uint earned){
        //The formula will divide by the heartrate to make it fair to those people who do weight training
        earned = calories1 / heartrate1 * workout_time1 / 2000;
    }

// 0x0000000000000000000000000000000000000000000000000000000061626364
// [1, 2, 3]
// 0x0000000000000000000000000000000000000000000000000000000061626365

    function exchange(address user2, uint amount) public {
        User storage sender = Users[msg.sender];
        require(sender.registered == true, "You have not registered.");

        require(sender.balance >= amount);
        require(amount >= 0);
        
        sender.balance -= amount;
        Users[user2].balance += amount;
    }

    function add_post(bytes32 userid, string memory context, uint time) public {
        User storage user_sender = Users[msg.sender];
        require(user_sender.registered == true, "You have not registered.");
        require(user_sender.userID == userid, "You must post for yourself");

        Posts.push( Post(userid, context, time) );
    }


// 0x0000000000000000000000000000000000000000000000000000000061626364
// [1, 2, 3]
// 0x0000000000000000000000000000000000000000000000000000000061626365


    function watchFivePosts(bytes32 userid) public view returns (string[] memory, uint[] memory) {
        User storage sender = Users[msg.sender];
        require(sender.registered == true, "You have not registered.");

        string [] memory curr_posts = new string [](5);
        uint [] memory curr_posts_time = new uint [](5);

        // try catch
        for (uint i = Posts.length-1; i > 0; i--) {
            if (userid == Posts[i].userID) {
                curr_posts[i] = Posts[i].context;
                curr_posts_time[i] = Posts[i].time;
            }
        }
        return (curr_posts, curr_posts_time);
    }


    function signContract(uint contractID) public {
        User storage sender = Users[msg.sender];
        require(sender.registered == true, "You have not registered.");
        require(sender.contractID == 0, "You've already signed a contract. Please cancel it before you sign a new one.");

        sender.contractID = contractID;

        sender.timeSigned = block.timestamp;
        // sender.time = DateTime();
    }

    function cancelContract() public {
        User storage sender = Users[msg.sender];
        require(sender.registered == true, "You have not registered.");

        sender.contractID = 0;
    }

    function commitContract() public {
        User storage sender = Users[msg.sender];
        uint curr_time = block.timestamp - sender.timeSigned;

        if (sender.contractID == 100) {
            if (curr_time >= 1 weeks && curr_time <= 1 weeks + 1 days) {
                if (sender.balance - sender.balance_reset >= 25){ sender.balance += 5;} 
                else { sender.balance -= 3;} 
            }
        } if (sender.contractID == 200) {
            if (curr_time >= 1 weeks && curr_time <= 1 weeks + 1 days) {
                if (sender.balance - sender.balance_reset >= 30){ sender.balance += 7;} 
                else { sender.balance -= 4;} 
            }
        } if (sender.contractID == 300) {
            if (curr_time >= 1 weeks && curr_time <= 1 weeks + 1 days) {
                if (sender.balance - sender.balance_reset >= 35){ sender.balance += 9;} 
                else {sender.balance -= 5;} 
            }
        }  
        sender.balance_reset = sender.balance;
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

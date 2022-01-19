// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract GymCoin {

    struct Exercise {
        bytes32 userID;   // short name (up to 32 bytes)
        uint deviceID;    // the device ID for user
        uint gymcoin;    //gym coin amount
    }

    struct User {
        bytes32 userID; // Unique ID for each user
        uint [] deviceIDs; // Unique ID for each device
        uint balance; // Balance of GymCoins
        uint contractID; // List of contracts signed
        bool registered; // true means one has already registered and cannot add_user again
    }

    // struct Platform {
    //     bytes32 [] userIDs; // Unique ID for each user 
    //     Post [] Posts;
    // }

    struct Post {
        bytes32 userID; // Unique ID for each user
        string context;
        string time;
    }

    mapping(address => User) public Users;      //TODO: after mapping address to User, what does Users do?
    Post[] public Posts;


    function add_user(bytes32 userid, uint [] memory deviceIDs, uint contractIDs) public {
        User storage sender = Users[msg.sender];
        require(!sender.registered, "You have already registered");

        sender.userID = userid;
        sender.deviceIDs = deviceIDs;
        sender.balance = 0;
        sender.contractID = contractIDs;
        sender.registered = true;
    }

    function add_exercise(bytes32 userid, uint deviceid, uint heartrate1, uint workout_time1, uint calories1) public {
        User storage sender = Users[msg.sender];
        require(sender.userID == userid, "Wrong User ID");

        // Check if the device is recorded
        bool Contain = false;
        for (uint i=0; i < sender.deviceIDs.length; i++) {
            if (deviceid == sender.deviceIDs[i]) { Contain = true; }
        }
        require(Contain == true, "Must use the correct device");

        sender.balance += reward(heartrate1, workout_time1, calories1);
    }


    function reward(uint heartrate1, uint workout_time1, uint calories1) public pure returns(uint earned){
        //The formula will divide by the heartrate to make it fair to those people who do weight training
        earned = calories1 / heartrate1 * workout_time1 / 2000;
    }


    function exchange(address user2, uint amount) public {
        User storage sender = Users[msg.sender];
        require(sender.balance >= amount);
        
        sender.balance -= amount; // Could be negative
        Users[user2].balance += amount;
    }

    function add_post(bytes32 userid, string memory context, string memory time) public {
        // Post storage sender = Posts[msg.sender];
        User storage user_sender = Users[msg.sender];
        require(user_sender.userID == userid, "You must post for yourself");
        // sender.userID = userid;
        // sender.context = context;
        // sender.time = time;

        Posts.push( Post(userid, context, time) );
    }

    function watchFivePosts(bytes32 userid) public view returns (string[] memory, string[] memory) {
        string [] memory curr_posts = new string [](5);
        string [] memory curr_posts_time = new string [](5);

        for (uint i=0; i < Posts.length; i++) {
            if (userid == Posts[i].userID) {
                curr_posts[i] = Posts[i].context;
                curr_posts_time[i] = Posts[i].time;
            }
        }
        return (curr_posts, curr_posts_time);
    }

    // function signContract(bytes32 userID, bytes32 contractID) public {

    // }

    // function cancelContract(bytes32 userID, bytes32 contractID) public {

    // }
    
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

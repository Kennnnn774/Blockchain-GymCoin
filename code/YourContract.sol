pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

// import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; 
import "@openzeppelin/contracts/utils/Strings.sol";
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract YourContract is Ownable {

  constructor() payable {
  }

  receive() external payable {}
  fallback() external payable {}

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
  }

  struct Post { // Could also do Like System
      bytes32 userID; // Unique ID for each user
      string context;
      uint time;
  }

  mapping(address => User) public Users;
  string public purpose = "";

  function fetchBalance() public {
        User storage sender = Users[msg.sender];
        purpose =  Strings.toString(sender.balance);
    }  


  function Register(bytes32 userID, uint [] memory deviceIDs) public {
        User storage sender = Users[msg.sender];
        require(!sender.registered, "You have already registered");

        sender.userID = userID;
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

  function add_exercise(bytes32 userID, uint deviceID, uint heart_rate, uint workout_time_in_minutes, uint calories) public {
        User storage sender = Users[msg.sender];
        require(sender.registered == true, "You have not registered.");
        require(sender.userID == userID, "Wrong User ID");

        // Check if the device is recorded
        bool Contain = false;
        for (uint i=0; i < sender.deviceIDs.length; i++) {
            if (deviceID == sender.deviceIDs[i]) { Contain = true; }
        }
        require(Contain == true, "Must use the correct device");
        // Reward
        sender.balance += reward(heart_rate, workout_time_in_minutes, calories);
  }

  function reward(uint heart_rate, uint workout_time_in_minutes, uint calories) private pure returns(uint earned){
      //The formula will divide by the heartrate to make it fair to those people who do weight training
      earned = calories / heart_rate * workout_time_in_minutes * 60 / 2000;
  }

  function transfer(address receiver, uint amount) public returns (bool) {
        // Teansfer GymCoin
        require(Users[msg.sender].registered && Users[receiver].registered, "Both users must be registered.");

        require(Users[msg.sender].balance >= amount, "Insufficient balance.");
        require(amount >= 0);
        // Modify balance
        Users[msg.sender].balance -= amount;
        Users[receiver].balance += amount;
        return true;
    }

  Post[] public Posts;

  function add_post(string memory context) public {
        User storage user_sender = Users[msg.sender];
        require(user_sender.registered == true, "You have not registered.");
        // require(user_sender.userID == userid, "You must post for yourself");
        Posts.push(Post(user_sender.userID,context, block.timestamp) );
  }

  function watchFivePosts(bytes32 userID) public view returns (string[] memory, uint[] memory) {
        User storage sender = Users[msg.sender];
        require(sender.registered == true, "You have not registered.");

        string [] memory curr_posts = new string [](5);
        uint [] memory curr_posts_time = new uint [](5);

        require(Posts.length >= 1, "No posts so far");
        //pre-process
        curr_posts[0] = "Empty";
        curr_posts_time[0] = block.timestamp;

        uint count = 0;
        for (uint i = Posts.length - 1; i > 0; i--) {
            if (userID == Posts[i].userID) {
                curr_posts[count] = Posts[i].context;
                curr_posts_time[count] = Posts[i].time;
                count ++;
                if (count == 5) {return (curr_posts, curr_posts_time);}
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
      // check the current balance when signing the contract
      sender.balance_reset = sender.balance;
  }

  function cancelContract() public {
      User storage sender = Users[msg.sender];
      require(sender.registered == true, "You have not registered.");

      sender.contractID = 0;
      sender.balance_reset = 0;
  }

  function commitContract() public {
      User storage sender = Users[msg.sender];
      uint curr_time = block.timestamp - sender.timeSigned;

      if (sender.contractID == 100) {
          if (curr_time >= 1 seconds && curr_time <= 1 weeks + 1 days) {
              if (sender.balance - sender.balance_reset >= 25){ sender.balance += 5;} 
              else { sender.balance -= 3;} 
          }
      } if (sender.contractID == 200) {
          if (curr_time >= 1 seconds && curr_time <= 1 weeks + 1 days) {
              if (sender.balance - sender.balance_reset >= 30){ sender.balance += 7;} 
              else { sender.balance -= 4;} 
          }
      } if (sender.contractID == 300) {
          if (curr_time >= 1 seconds && curr_time <= 1 weeks + 1 days) {
              if (sender.balance - sender.balance_reset >= 35){ sender.balance += 9;} 
              else {sender.balance -= 5;} 
          }
      }  
      sender.balance_reset = sender.balance;
  }

}
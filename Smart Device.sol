pragma solidity >=0.7.0 <0.9.0;

/** 
 * @title Smart Device
 * @dev collect user informaiton from the smart device and use that for gym coin exchange
 */
contract Smart_Device {
   

    struct user_info {
        bytes32 userID;   // short name (up to 32 bytes)
        int deviceID;    // the device ID for user
        //int heartrate;   //user average heartrate during the workout
        //int workout_type; // 1 represent cardio; 2 present weight training
        //int workout_time; // the length of the work out (unit in seconds); we can pre-process the startTime and endTime to get the workout interval.
        //int calories; // total calories for each workout;
        int gymcoin;    //gym coin amount
    }

    
    user_info[] public info;

    /** 
     * @dev load all the information into smart contract .
     */
    constructor(bytes32 userid, int deviceid, int heartrate1, int workout_type1, int workout_time1, int calories1) {
            //pushing the necessary information to the proposal list
        info.push(user_info({
            userID: userid,
            deviceID: deviceid,
            gymcoin: reward(heartrate1,workout_type1,workout_time1,calories1)
            }));

        // call the reward function below to add user amount into gym coin
        }

    /** 
     * @dev reward user gymcoin base on their workout type, workout time, calories and heartrate
     */
    function reward(int heartrate1, int workout_type1, int workout_time1, int calories1) public view returns(int earned){
        //how to reward system work, return the amount of gymcoin user use in the exercise
        if (workout_type1 == 1 && 140 < heartrate1 && heartrate1 < 170){
            //check the workout time and see if the user is cheating or not. However, using the new formula below avoid that happen
            
        }
        // it is cardio workout, which means the calories1 tend to be higher; 
        //so the formula will divide by the heartrate to make it fair to those people who do weight training
        earned = calories1 / heartrate1 * workout_time1/2000;
    }

    
    
}
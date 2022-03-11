# Blokchain-GymCoin

## Main Page
Our Main website: http://dsc180a03_gymcoin.surge.sh/ -- It covers our project White Paper, User Instruction, User Interaction Interface (Deploy), and Wallet.

The template and front-end code are collected at this repo: https://github.com/Kennnnn774/Gym-Coin-Website

### Abstract

Nowadays, physical fitness and bodybuilding have been unprecedentedly popular. While it is usually easy for people to start exercises or diets, they may find it difficult to persevere for lack of inner-drive. There are many factors contributing to this phenomenon – busy schedules, intense training plans, lack of workout buddies, etc. All these factors gradually lead to a loss in motivation, causing people to become more reluctant to daily exercise, and eventually stop working out completely. Even though pre-workout products can relieve this unwillingness, its effect is temporary and can lead to dependence on the product. With the development of technology and the global market, blockchain technology and cryptocurrency inspired us to develop a blockchain-based application that incorporates exercising, entertainment, and socialization through the implementation of a platform that rewards users for actively staying fit. By creating such a platform that targets people’s demand for personalized socializing and motivation for exercising, we expect to promote our GymCoin with a high socio-economic value and, broadly, a healthy lifestyle for people as well as the growth of the gym industry.


### 1. Introduction 
The idea is that our users can connect to their smart devices like watches/rings, choose their desired type of exercise, and trace their heart rate & time for calories consumption. They will be rewarded a certain amount of GymCoins for calories burnt. GymCoins can then be used in a NFT platform where users can claim ownership to images of their interest and trade with each other. We could also potentially explore a gaming platform. Note that one can also trade GymCoins for cash with other users. 

Data storage and management as well as the trading process will be done on the Ethereum blockchain using Solidity and the User Interface will be derived from the Scaffold-ETH application. We expect this integrated platform to promote the circulation of GymCoin within its community and increase GymCoins’ value through interactions. With the rise of fitness tech and the gradual maturity of blockchain technology, we expect GymCoin to bridge the two markets.

![alt text](https://github.com/feifanjasmineguan/Blockchain-GymCoin/blob/main/readme_imgs/trend.png)


### 3. Why (GymCoin on) Blockchain
#### Incentive Reward System
- GymCoin is a sustainable incentive system that rewards exercise 
  - The incentive is so far monetary, but can also be expanded to others
  - Similar concept can be applied to any currently not rewarded activities such as public service
- Due to proof of work and immutability, the incentive won’t be tampered with
- GymCoin as Fungible Token (ERC20): can be exchanged among users
- Characters as Non-Fungible Token (ERC721): unique digital identifier that can’t be exchanged for similar kinds
 
It serves as vending machines, with secure transactions, lower compliance costs, and higher transaction speed.
- Authentic transaction verified and confirmed by participants:
  - Transactions can only go through if it’s verified by all parties involved
- Immutable transactions:
  - One a transaction goes through, it can’t be altered or deleted
- Decentralized data with no fee required:
  - Users directly interact with each other through addresses without the need to go through intermediary parties
- Non-intermediary rewards for producers:
  - No transaction or commission fee generated since no intermediary 
#### Feasibility – competitive among other decentralized industrial projects.
- Banking/Fintech
- Healthcare/Insurance
- Supply Chain Management
- Gaming
#### Traceability 
– efficient contract management and data query.



### 2. Core Concept
Users: the core of GymCoin. We focus on the quantity and quality of users and strive to add socio-economic values to our users by implementing an interactive platform to motivate users and as well as smart contracting for monetary incentive. There are naturally two types of users—producers and consumers. A consumer is one that participates in daily work-outs, purchases gym tutorials, exchanges for GymCoin rewards, claims ownership to interesting collections of images, and interacts with others. A producer is one that trades GymCoins or shares his exercise experience and expertise with the exchange of GymCoins. 

Smart Contracts: a monetary incentive to users, rewarding users with GymCoins and cash. We developed layered plans for cash bonuses catered to different needs of our users (Specified later).
Crypto-currency: crypto-transactions allowed between contracts and users to create a safe environment. Liquidity is preferred and promoted by the mechanisms.

Scaffold-ETH: a good visualization tool for smart contracts with diverse methods for User Interface. It would be the place of our main page, attracts users to interact with our smart contracts and enables users to query their current status/collections.



### 3. GymCoin Mechanism
- Access smart devices like watches/rings or running machines, choose your own type of exercise, and trace your heart rate & time for Calories.
- ERC-20 compliant
- Get GymCoins for a certain amount of Calories, with a daily limit of 10 GymCoins.
- GymCoins can be transferred and have no amount limit.
- Multiple applications:
  - Layered Plans for cash bonus:
    - Get 5 extra coins for 25 GymCoin per week and 3 penalty
    - Get 7 extra coins for 30 GymCoin per week and 4 penalty
    - Get 9 extra coins for 35 GymCoin per week and 5 penalty

Post about your exercise experience and share with your friends!

![alt text](https://github.com/feifanjasmineguan/Blockchain-GymCoin/blob/main/readme_imgs/workflow.png)

### 4. FitBit Integration
Tracking user heartrates can be done using a FitBit device in which the user allows the GymCoin application to access their FitBit account's profile, devices, activities, and heartrate. The GymCoin application is designed to receive user data through OAuth 2.0 with PKCE for the most secure authorization flow. User data such as calories and heartrate can then be accessed by making a request to the GymCoin API server which makes the proper request to the FitBit API.

Example of a request which returns calorie activity:
```bash
curl -X POST -H "content-type:application/json" "http://localhost:8080/" --data '{ "id": 1, "data": { "endpoint": "/1/user/-/activities/list.json", "beforeDate": "2022-02-19", "offset": 0, "limit": 5, "sort": "desc"} }'
```

The GymCoin API can then interact with the Ethereum blockchain as a Chainlink external adapter hosted by AWS Lambda or uploaded as an external adapter on the Chainlink market. A node operator must add it as an external adapter or GymCoin can create its own Chainlink node with AWS EC2.

![alt text](https://github.com/feifanjasmineguan/Blockchain-GymCoin/blob/main/readme_imgs/fitbit_oauth.png)


### 5. GymCoin Usage
In the NFT platform, we would like to create multiple interesting collections with different topics which can be claimed by users with a certain amount of GymCoins and user-levels. The collections would be limited and can be transferred among users. We hope to bring interesting images as well as those with social responsibilities to our users and increase the socio-economic value of them.

In the gaming platform, users can exchange GymCoins to customize their personal avatar with things like clothes, accessories, shoes, glasses, bags, etc. We will also include mechanisms to change  their physical appearance such as height, muscles, body fat, haircut, facial expressions, etc. Based on their involvement, users can increase their character level and unlock more friend connections and users to play with. Further down the line, we will also implement emotes and other methods of interaction. With these social interactions in place, socialization and communication between GymCoin users is promoted as well as the circulation of GymCoins.


### 6. Rewards System & Proof of Work
In order to connect to the GymCoin platform, users are required to connect to smart devices and select the corresponding exercise. Using Apple Watches as an example, it will automatically calculate calories burnt through the user's heart rate. This is also our mechanism to make sure users don’t cheat since their heart rate can not be easily imitated by machines. With the guidance of health experts, we will determine the exchange rate between calories burnt and GymCoins. Once users exchange GymCoins from calories burnt, they can exchange them for cash through the use of smart-contracts or use them directly in the GymCoin social gaming platform. Also, users are recommended to use MetaMask as their interface to connect to our application website, which allows them to keep track of their behavior and double check their identities at each step with a high level of security.

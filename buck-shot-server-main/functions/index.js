const functions = require("firebase-functions");
const {Firestore, Timestamp} = require('@google-cloud/firestore');

var admin = require("firebase-admin");

var serviceAccount = require("./shot-buck-firebase-adminsdk-8miab-e01e84401c.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const bcrypt = require("bcrypt")
const saltRounds = 10

const db = admin.firestore();

/////////////// USER LAND

// /createUser
exports.createUser = functions.https.onRequest(async (req, res) => {
    const userId = req.body.userId;
    const password = req.body.password;
    const userDataRef = db.collection("users").doc(userId);
    const userDocumentSnapshot = await userDataRef.get();
    // Return user data if found
    if (userDocumentSnapshot.exists) {
        res.status(400).json({message: "User Id Taken", status: 400}).send();
    } else {
        const hashedPassword = await bcrypt.hash(password, saltRounds);
        userDataRef.set({ userId: userId, password: hashedPassword }, { merge: true });
        res.status(200).send();
    }
});

// /addOrEditUserData
exports.addOrEditUserData = functions.https.onRequest(async (req, res) => {
    // Get user data based on user id
    const userId = req.body.userId;
    const password = req.body.password;
    const userData = req.body.data;
    const userDataRef = db.collection("users").doc(userId);
    const userDocumentSnapshot = await userDataRef.get();
    // Return user data if found
    if (userDocumentSnapshot.exists) {
        const userDocumentData = userDocumentSnapshot.data();
        // Check to see if the given password matches hashed password for user
        if (await bcrypt.compare(password, userDocumentData.password)) {
            // Merge new data into user data object
            userDataRef.set({ data: userData }, { merge: true });
        } else {
            res.status(400).json({message: "Invalid password", status: 400});
        }
        res.status(200).json(userDocumentData);
    } else {
        res.status(400).json({message: "User Not Found", status: 400});
    }
});

// /getUserData
exports.getUserData = functions.https.onRequest(async (req, res) => {
    // Get user data based on user id
    const userId = req.body.userId;
    console.log(userId)
    const userDataRef = db.collection("users").doc(userId);
    const userDocumentSnapshot = await userDataRef.get();
    // Return user data if found
    if (userDocumentSnapshot.exists) {
        const userDocumentData = userDocumentSnapshot.data();
        res.status(200).json(userDocumentData.data);
    } else {
        res.status(400).json({message: "User Not Found", status: 400})
    }
});


// /getAllUserData
exports.getAllUserData = functions.https.onRequest(async (req, res) => {
    // This should scale fine 
    let allUserDataArray = [];
    // Get all users
    const allUserData = await db
        .collection("users")
        .get();
    // check if we even need to be here at all
    if (allUserData.size > 0) {
        allUserData.forEach((userDoc) => {
            const userId= userDoc.data().userId;
            const docData = userDoc.data().data; 
            const userObj = {};
            userObj[userId] = docData;
            allUserDataArray.push({userObj});
        });
        res.status(200).json({data: allUserDataArray});
    } else {
        res.status(400).json({message: "No user data found", status: 400});
    }
});


/////////////// LEVEL LAND

// /addScoreToLevel
exports.addScoreToLevel = functions.https.onRequest(async (req, res) => {
    // Get user data
    const userId = req.body.userId;
    const levelId = req.body.levelId;
    const password = req.body.password;
    const scoreValue = req.body.scoreValue;
    const levelDataRef = db.collection("levels").doc(levelId);
    const levelScoreRef = levelDataRef.collection("scores");

    // check to see if the user exists
    const userDataRef = db.collection("users").doc(userId);
    const userDocumentSnapshot = await userDataRef.get();
    // See if user data exists
    if (userDocumentSnapshot.exists) {
        const userDocumentData = userDocumentSnapshot.data();
        // Check to see if the given password matches hashed password for user
        if (await bcrypt.compare(password, userDocumentData.password)) {
            // Merge new data into user data object
            const timestamp = Date.now().toString();
            const scoreObject = {
                "userId": userId,
                "scoreValue": scoreValue,
            }
            levelDataRef.set({active:true});
            levelScoreRef.doc(timestamp).set(scoreObject);
            res.status(200).send();
        } else {
            res.status(400).json({message: "Invalid password", status: 400});
        }
    } else {
        res.status(400).json({message: "User Not Found", status: 400})
    }
});

// getScoresForLevel
exports.getScoresForLevel = functions.https.onRequest(async (req, res) => {
    // Get level data
    const levelId = req.body.levelId;
    // This should scale fine 
    let scoreDataArr = [];
    // Get all users
    const allScoreData = await db
        .collection("levels")
        .doc(levelId)
        .collection("scores")
        .get();
    // check if we even need to be here at all
    if (allScoreData.size > 0) {
        allScoreData.forEach((scoreDoc) => {
            const userId= scoreDoc.data().userId;
            const scoreVal = scoreDoc.data().scoreVal; 
            const timestamp = scoreDoc.id;
            const userObj = {
                userId: userId,
                scoreVal: scoreVal,
                timestamp: timestamp,
            };
            scoreDataArr.push(userObj);
        });
        res.status(200).json({data: scoreDataArr});
    } else {
        res.status(400).json({message: "No score data found", status: 400});
    }
});

//getAllLevels
exports.getAllLevels = functions.https.onRequest(async (req, res) => {
    // This should scale fine 
    let levelDataArr = [];
    // Get all users
    const allLevels = await db
        .collection("levels")
        .get();
    // check if we even need to be here at all
    if (allLevels.size > 0) {
        allLevels.forEach((levelDoc) => {
            levelDataArr.push(levelDoc.id);
        });
        res.status(200).json(levelDataArr);
    } else {
        res.status(400).json({message: "No level data found", status: 400});
    }
});

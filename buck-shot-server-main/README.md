# 💥Buck-shot-server💥

The BSS stores data in a NoSQL document database.

User objects are structured in the following way:

```
{
    users: 
    [
        {
            userId: A string unique to only this user, no two can be alike,
            password: a salted hash of the users password
            data: {
                Any key: any value
            }
        }
    ]
}

```

Level objects are stored in the following way:

```
{
    levels : [
        "level_one" : {
            scores : [
                timestamp : {
                    userId: string,
                    scoreVal: string,
                }
            ],
            active: true, // will always be set to true if this document exists...don't ask
        }
    ]
}
```

# End points:
# Users:
## `/create`
### `https://us-central1-shot-buck.cloudfunctions.net/createUser`

Creates a user with the user id and password

Request body format:
```
{
    userId: string,
    password: string,
}
```
Success Response:
```
{
    status: 200
}
```
Failure response:
```
{ 
    message: "User Id Taken",
    status: 400,
}
```


## `/getUserData`
### `https://us-central1-shot-buck.cloudfunctions.net/getUserData`
Returns user data object 
Request body format:
```
{
    userId: string,
}
```
Success Response:
```
{
    status: 200,
    data: { userDataObject }
}
```
Failure response:
```
{ 
    message: "User Not Found",
    status: 400,
}
```
## `/addOrEditUserData`
### `https://us-central1-shot-buck.cloudfunctions.net/addOrEditUserData`
Adds or edits a user data, only if the password provided matches the password of the user.
Request body format:
```
{
    userId: string,
    password: string,
    data: {
        key: value
    }
}
```
Success Response:
```
{
    status: 200
}
```
Failure response:
```
{ 
    message: ["User Not Found", "Invalid Password"],
    status: 400,
}
```
## `/getAllUserData`
### `https://us-central1-shot-buck.cloudfunctions.net/editUserData`
Returns every user data object
Request body format:
```
{
    userId: string,
    password: string,
}
```
Success Response:
```
{
    status: 200,
    data : { all the user data }
}
```
Failure response:
```
{ 
    message: "No user data found",
    status: 400,
}
```
# Levels:
### LEVELS!! !!

A couple notes on how levels work in the data base:

adding a score to a level with a level id that does not exist just makes a level with that id.

## /addScoreToLevel
## `https://us-central1-shot-buck.cloudfunctions.net/addScoreToLevel`
Adds a score value associated with a userId with the users password to authenticate
```
{
    leveId: string,
    userId: string,
    password: string,
    scoreValue: string,
}
```
Success Response:
```
{
    status: 200,
}
```
Failure response:
```
{ 
    message: ["Level not found", "Invalid password"],
    status: 400,
}
```
## /getScoresForLevel
## `https://us-central1-shot-buck.cloudfunctions.net/getScoresForLevel`
```
{
    leveId: string,
    userId: string,
    scoreValue: string,
}
```
Success Response:
```
{
    status: 200,
    data: [
        {
            userId: the users id,
            scoreVal: the score value as a string
            timestamp: UTC Timestamp
        },
        {
            userId: another users id,
            scoreVal: another score value as a string
            timestamp: another UTC Timestamp
        },
    ]
}
```
Failure response:
```
{ 
    message: "No Score data found",
    status: 400,
}
```
## /getAllLevels
## `https://us-central1-shot-buck.cloudfunctions.net/getAllLevels`
```
{
    leveId: string,
}
```
Success Response:
```
{
    status: 200,
    data: [
        "level_one",
        "level_two"
    ]
}
```
Failure response:
```
{ 
    message: "No level data found",
    status: 400,
}
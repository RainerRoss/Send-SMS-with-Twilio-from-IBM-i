# Send SMS with Twilio from IBM i

## How does it work

Twilio provides a Node.js REST API to send SMS messages. With a simple RPG program you send the SMS data to the webservice on your IBM i (formerly AS/400) written in Node.js. Once the message arrived the Node.js program send the message with the Twilio REST-API.

## The JSON SMS data created with the RPG program
```
{"from":"+123456789", "to":"+123456789" , "text":"My Message"}
```
## You need
```
- Node.js version 10 or higher - actually Node.js v18 
  Install Node.js with Access Client Solutions Open Source Package Management or with "yum install nodejs18"
- Install Twilio Node.js API: npm install twilio
- The Twilio credentials - accountSid, authToken - from www.twilio.com/console
```
## Check your Node.js version
```
5250> qsh
$ node -v
v18.0.0   
```
## Manual Install
```
5250> qsh
$ mkdir -p /home/node  (for the sendSMS.js)
```
## Start the Node.js program on your IBM i
```
5250> qsh
$ node /home/node/sendSMS.js
```
## Test your Node.js webservice with SQL
```
values QSYS2.HTTP_POST(
  'http://(IP from your IBM i):8080/sendsms',
  '{
    "from": "+49678901234",
    "to":   "+49171456789",
    "text": "My Message to you!"
   }',
  '{
    "header": "Content-Type,application/json; charset=utf-8"      
   }'
);
```

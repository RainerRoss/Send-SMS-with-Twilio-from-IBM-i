# Send SMS with Twilio from IBM i

# How does it works

Twilio provides a Node.js API to send SMS messages. This solution give you a simple RPGLE program to send the SMS data to a DataQueue. When the SMS message is sent to the DataQueue a Node.js program wait for new SMS messages. Once the message arrived the Node.js program send the message with the Twilio REST-API.

# You need
```
The TWILIO credentials - accountSid and authToken - from www.twilio.com/console
Node.js 4.x 5733-OPS Option 5
YAJL from Scott Klement www.scottklement.com/yajl/ 
```

Go [here](https://www.ibm.com/developerworks/community/wikis/home?lang=en#!/wiki/IBM%20i%20Technology%20Updates/page/Node.js) to get started with Node.js on IBM i.

#Once you have installed Node.js 4.x set Node.js to V4

```
5250> qsh
$ /QOpenSys/QIBM/ProdData/OPS/Node4/bin/nodever.sh 4
```

#Check your Node.js version

```
5250> qsh
$ node -v
for example v4.4.6  
```

#Enable QRCVDTAQ wait for Node.js

```
You'll find the Class iDataQueue in the file /QOpenSys/QIBM/ProdData/OPS/Node4/os400/xstoolkit/lib/idataq.js
copy this file to the new file /QOpenSys/QIBM/ProdData/OPS/Node4/os400/xstoolkit/lib/idataq2.js
and change the following statements:

line 70: iDataQueue.prototype.receiveFromDataQueue = function(name, lib, length, wait, cb) {
line 76: pgm.addParam(wait, "5p0");
```
#Manual Install
Create the following Directories

```
5250> qsh
$ mkdir -p /home/node  (for the sendSMSDataFromQueue.js)
```

#Start the program on your IBM i

```
5250> qsh
$ node /home/node/sendSMSDataFromQueue.js
```

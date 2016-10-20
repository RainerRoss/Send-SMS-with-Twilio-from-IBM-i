# Send SMS with Twilio from IBM i

# How does it works

Twilio provides a Node.js API to send SMS messages. This solution give you a simple RPGLE program to send the SMS data to a DataQueue. When the SMS message is sent to the DataQueue a Node.js program wait for new SMS messages. Once the message arrived the Node.js program send the message with the Twilio REST-API.     

you need V7R1 and Node.js v4.x delivered with 5733-OPS
```
5733-OPS Option 1 	Node.js 0.x
5733-OPS Option 5 	Node.js 4.x
```
Go [here](https://www.ibm.com/developerworks/community/wikis/home?lang=en#!/wiki/IBM%20i%20Technology%20Updates/page/Node.js) to get started with Node.js on IBM i.

#When you have installed Node.js 4.x set Node.js to V4

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

#Manual Install
Create the following Directories

```
5250> qsh
$ mkdir -p /home/node  (for the webservice.js)
```

#Git Clone Install
From a PASE shell enter the following

```
5250> qsh
$ git clone git@github.com:RainerRoss/webservice-IBM-i-and-Node.js.git
```

#Start the webservice on your IBM i

```
5250> qsh
$ node /home/node/webservice.js
```

#Start the webservice in your browser

http://yourip:8080/MyWebservice?name=A%25

#The result is the following JSON String
```
{
   "success":true,
   "errmsg":"",
   "records":2,
   "items":[
      {
         "CUSNUM":"846283",
         "LSTNAM":"Alison",
         "CITY":"Isle",
         "BALDUE":"10.00"
      },
      {
         "CUSNUM":"583990",
         "LSTNAM":"Abraham",
         "CITY":"Isle",
         "BALDUE":"500.00" 
      }
   ]
}
```

If the port `8080` is used on your machine please use another port and change it in the `webservice.js - line 27` 

check the port on IBM i: 

```
5250> netstat *cnn
```

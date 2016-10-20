var xt		= require('/QOpenSys/QIBM/ProdData/OPS/Node4/os400/xstoolkit/lib/itoolkit');
var dq		= require('/QOpenSys/QIBM/ProdData/OPS/Node4/os400/xstoolkit/lib/idataq2');
var twilio	= require('twilio');

var accountSid  = 'abcdefghijklmn'; // Your Account SID from www.twilio.com/console
var authToken   = 'abcdefghijklmn'; // Your Auth Token from www.twilio.com/console

var conn	= new xt.iConn('*LOCAL', 'User', 'Password'); // Your User and Password on your IBM i
var dtq		= new dq.iDataQueue(conn);
var client	= new twilio.RestClient(accountSid, authToken);

var data = '';

while (data.body !== '*end') {
    data = JSON.parse(dtq.receiveFromDataQueue('SNDSMSQ', 'MYLIB', 5000, -1));
    console.log('data: ' + JSON.stringify(data));
    sendSMS(data);
}

function sendSMS(data) {
    client.messages.create({
	body: data.body,  // SMS body
	to:   data.to,	  // SMS to number
	from: data.from	  // SMS from a valid Twilio number
    }, function(err, message) {
	if (err) {
            console.error(err.message);
	}
    });
} 

const qs		    = require('querystringify');
const http			= require('http');
const port			= 8080;

const accountSid	= 'abcdefghijklmn';							// Your Account SID from www.twilio.com/console
const authToken     = 'abcdefghijklmn';							// Your Auth Token from www.twilio.com/console
const client		= require('twilio')(accountSid, authToken);


let response        = new Object();
response.success	= true;
response.error		= '';


function sendSMS(data) {
	client.messages
		.create({
			body: data.text,
			from: data.from,
			to:	  data.to 
		})
		.then(message => console.log(message.sid));
}


http.createServer(function(req, res) {
	console.log('URL: '			    + req.url);
	console.log('Method: '			+ req.method);
	console.log('Headers: '			+ JSON.stringify(req.headers));
	console.log('Host: '			+ req.headers.host);
	console.log('Content-Type: '	+ req.headers['content-type']);
	console.log('Content-Length: '	+ req.headers['content-length']);
	
	if (req.method === 'POST') {
		let body = new Array();

		req.on('data', function(data) {
		body.push(data);
		})
		req.on('end', function() {
			let data = JSON.parse(Buffer.concat(body).toString());
			console.log('Data: ' + JSON.stringify(data));
			sendSMS(data);
			res.writeHead(200, {'Content-Type': 'application/json'});
			res.end(JSON.stringify(response));
		})
	} 
	if (req.method === 'GET') {
		let string = req.url;
		if (string.indexOf("?") > 0) {
			string = string.substr(string.indexOf("?"));
		}
		let data = qs.parse(string);
		console.log('Data: ' + JSON.stringify(data));
		sendSMS(data);
		res.writeHead(200, {'Content-Type': 'application/json'});
		res.end(JSON.stringify(response));
	}
}).listen(port);

console.log('Server running at Port: ' + port);

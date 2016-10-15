var http	= require('http');
var url		= require('url');
var querystring	= require('querystring');
var db		= require('/QOpenSys/QIBM/ProdData/OPS/Node4/os400/db2i/lib/db2');
var util	= require('util');

var responseData = {
    success: '',
    errmsg: '',
    records: '',
    items: ''
};

http.createServer(function (request, response) {
    var start = timerStart();	
    var pathname = url.parse(request.url).pathname;
    var values = querystring.parse(url.parse(request.url).query);
	
    console.log('Pathname: ' + pathname);
    console.log('Querystring: ' + url.parse(request.url).query);	
    console.log('Values:' + JSON.stringify(values));

    response.writeHead(200, {'Content-Type': 'application/json'});
    response.end(readCustomers(values.name));
	
    console.log('Runtime: ' + timerEnd(start));
}).listen(8080);

function readCustomers(value) {
    var select = 'SELECT CUSNUM, trim(LSTNAM) as lstnam, trim(CITY) as City, BALDUE FROM QCUSTCDT';
    var where  = util.format("where lstnam like '%s'", value);
    var sql    = select + ' ' + where;
    var data   = '';
    console.log("Sql: " + sql);
    db.init();
    db.conn("*LOCAL");
    db.exec("SET SCHEMA QIWS");
    db.exec(sql, function(rows) {
			data = createResponse(rows);
    });
    db.close;
    return data;
}

function createResponse(rows) {
    if (rows.length > 0) {
	responseData.success = true;
	responseData.errmsg  = '';
	responseData.records = rows.length;
	responseData.items   = rows;
    } else {
	responseData.success = false;
	responseData.errmsg  = 'No records found';
	responseData.records = rows.length;
	responseData.items   = '';
    }
    return JSON.stringify(responseData);
}

function timerStart() {
    return (new Date()).getTime();
}

function timerEnd(start) {
    return ((new Date()).getTime() - start) + "ms";
}

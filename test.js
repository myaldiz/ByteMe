var http     = require("http");
var querystring = require('querystring');

const API  = process.argv[2]; // API
const ID   = process.argv[3]; // ID
const _req = process.argv[4]; // req

let http_method = "GET";
let url = "url"
let postData = "";
let flag = false;
let _headers = "";

switch(API) {
    case "browse":
        url = "browse";
        _headers = {"Content-Type": "application/json"};
        break;

    case "add":
        http_method = "POST";
        url = "add";
        postData = JSON.stringify(
            {    
                "Request": "Add_event",     
                "User": {   
                    "email": "user1@gmail.com",      
                    "pw_hash": "XXA83jd3kljsdf",    
                    "ip": "143.248.143.29"  
                },      
                "speaker":{     
                    "name": "Zombie"   
                },      
                "Event": {      
                    "abstract": "BlaBla",       
                    "place": "Kaist",       
                    "time": "2018-11-03 03:01:00.914138+00:00",         
                    "title": "Zombies",         
                    "details": "Blabla",
                    "poster_image": "imageimage" 
                }       
            }
        );
        _headers = {
            "Content-Type": "application/json",
            'Content-Length': postData.length
        };
        break;

    case "del":
        http_method = "DELETE";
        url = "delete/"+ID;
        _headers = {
            "Content-Type": "application/json",
            'Content-Length': postData.length
        };
        break;

    case "mod":
        http_method = "POST";
        url = "modify/"+ID;
        postData = JSON.stringify(
            {
                "Request": "Modify_event",
                "User": {   
                    "email": "user1@gmail.com",      
                    "pw_hash": "XXA83jd3kljsdf",    
                    "ip": "143.248.143.29"  
                },   
                "Event": {
                    "abstract": "BlaBla",
                    "place": "Kaist",
                    "time": "2018-11-03 03:01:00.914138+00:00",         
                    "title": "Zombies",         
                    "details": "Blabla",
                    "poster_image": "imageimage" 
                }
            }
        )
        _headers = {
            "Content-Type": "application/json",
            'Content-Length': postData.length
        };
        break;

    case "approve":
        http_method = "POST";
        url = "request/approvel/"+ID;
        postData = querystring.stringify({req: _req});
        _headers = {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Content-Length': Buffer.byteLength(postData)
        }
        break;
}

var options = {
    host: "127.0.0.1",
    port: "8000",
    path: "/api/v1/event/"+url,
    method: http_method,
    headers: _headers
};

if(flag) form.pipe(req);

const req = http.request(options, (res) => {
    console.log(`STATUS: ${res.statusCode}\n`);
    console.log(`HEADERS: ${JSON.stringify(res.headers)}\n`);
    // res.setEncoding('utf8');
    res.on('data', (chunk) => {
        console.log(`BODY: ${chunk}\n`);
    });
    res.on('end', () => {
        console.log('No more data in response.');
    });
});


// // write data to request body
req.write(postData);

req.on('error', (e) => {
    console.error(`problem with request: ${e.message}`);
});

req.end();
var http     = require("http");
var querystring = require('querystring');

const username = process.argv[2] 
const password = process.argv[3] 
const API  = process.argv[4]; // API
const token = process.argv[5]; // Token
const ID   = process.argv[6]; // ID
const _req = process.argv[7]; // req 


let http_method = "GET";
let url = "url"
let postData = "";
let flag = false;
let _headers = "";

function makeid() {
    var text = "";
    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  
    for (var i = 0; i < 5; i++)
      text += possible.charAt(Math.floor(Math.random() * possible.length));
  
    return text;
  }

switch(API) {
    case "browse?type=all":
        url = "event/browse?type=all";
        _headers = {
            "Content-Type": "application/json",
            'Authorization': 'Token '+token
        };
        break;

    case "browse?type=attending":
        url = "event/browse?type=attending";
        _headers = {
            "Content-Type": "application/json",
            'Authorization': 'Token '+token
        };
        break;    

    case "browse?type=created":
        url = "event/browse?type=created";
        _headers = {
            "Content-Type": "application/json",
            'Authorization': 'Token '+token
        };
        break;

    case "add":
        http_method = "POST";
        url = "event/add";
        postData = JSON.stringify(
            {    
                "Request": "Add_event",     
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
                    "speaker": {
                        "name": "Steve",
                        "univ": "KAIST",
                        "speakerEmail": "Steveeee@email.com"
                    },  
                    "poster_image": "imageimage" 
                }       
            }
        );
        _headers = {
            "Content-Type": "application/json",
            'Content-Length': postData.length,
            'Authorization': 'Token '+token
        };
        break;

    case "del":
        http_method = "DELETE";
        url = "event/delete/"+ID;
        _headers = {
            "Content-Type": "application/json",
            'Content-Length': postData.length,
            'Authorization': 'Token '+token
        };
        break;

    case "mod":
        http_method = "POST";
        url = "event/modify/"+ID;
        postData = JSON.stringify(
            {
                "Request": "Modify_event",
                "User": {   
                    "email": "user1@gmail.com",      
                    "pw_hash": "XXA83jd3kljsdf",    
                    "ip": "143.248.143.29"  
                },    
                "Event": {
                    "abstract": "Superman is the best",
                    "place": "Kaist",
                    "time": "2018-11-03 03:01:00.914138+00:00",         
                    "title": "Superman",         
                    "details": "Blabla",
                    "poster_image": "imageimage",
                    "speaker": {
                        "name": "Harlem",
                        "univ": "KAIST",
                        "speakerEmail": "Harlem@email.com"
                    },  
                }
            }
        )
        _headers = {
            "Content-Type": "application/json",
            'Content-Length': postData.length,
            'Authorization': 'Token '+token
        };
        break;

    case "approve":
        http_method = "POST";
        url = "event/request/approvel/"+ID;
        postData = querystring.stringify({req: _req});
        _headers = {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Content-Length': Buffer.byteLength(postData),
            'Authorization': 'Token '+token
        }
        break;

    case "register":
        http_method = "POST";
        url = "account/register"
        postData = JSON.stringify(
            {
                "Request": "Sign_up",
                "User": {
                    "id": "Harlem",
                    "email": "Harlem@kaist.ac.kr",
                    "pw_hash": "password@",
                    "type": "normal",	// or admin
                    "ip": "143.248.143.29"
                }
            }
        );
        _headers = {
            'Content-Type': 'application/json',
            'Content-Length': postData.length,
            'Authorization': 'Token '+token
        }
        break;
    
    case "attend":
        http_method = "POST";
        url = "event/attend/"+ID
        _headers = {
            'Content-Type': 'application/json',
            'Content-Length': postData.length,
            'Authorization': 'Token '+token
        }
        break;

    case "unattend":
        http_method = "POST";
        url = "event/unattend/"+ID
        _headers = {
            'Content-Type': 'application/json',
            'Content-Length': postData.length,
            'Authorization': 'Token '+token
        }
        break;
    
    case "tags":
        http_method = "GET";
        url = "event/tag/browse/"+ID
        _headers = {
            'Content-Type': 'application/json',
            'Content-Length': postData.length,
            'Authorization': 'Token '+token
        }
        break;   

    case "changetags":
        http_method = "POST";
        url = "event/tag/change/"+ID
        postData = JSON.stringify(
            {
                "Request": "change_tag",
                "Tags":
                [
                    {
                        "name":"Visualization",
                    },
                    {
                        "name":"Graphic",
                    }
                ]
            }
        )
        _headers = {
            'Content-Type': 'application/json',
            'Content-Length': postData.length,
            'Authorization': 'Token '+token
        }
        break;  
    
    case "profile":
        http_method = "GET";
        url = "account/profile"
        _headers = {
            'Content-Type': 'application/json',
            'Content-Length': postData.length,
            'Authorization': 'Token '+token
        }
        break;   
    
    case "updateprofile":
        http_method = "POST"
        url = "account/modify"
        postData = JSON.stringify(
            {
                "Request": "Modify_profile",
                "dept": "Computer Science",
                "tags":
                [
                    {
                        "name": "Visualization"
                    },
                    {
                        "name": "Graphics"
                    },
                ]
            }
        )
        _headers = {
            'Content-Type': 'application/json',
            'Content-Length': postData.length,
            'Authorization': 'Token '+token
        }
        break;
        
    case "login":
        http_method = "POST"
        url = "account/api-token-auth/"
        postData = JSON.stringify(
            {
                "username": username, 
                "password": password
            }
        );
        _headers = {
            'Content-Type': 'application/json',
            'Content-Length': Buffer.byteLength(postData),
        }
        break;  
    
    

}

var options = {
    url: "127.0.0.1",
    port: "8000",
    path: "/api/v1/"+url,
    method: http_method,
    headers: _headers,
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
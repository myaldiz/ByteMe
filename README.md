# ByteMe, Unified Event Sharing Platform

Please don't forget to write README.md files for others to understand..


## Tasks

* UI
* Server
* DB


## Things to be careful in the repo!!

* Do not include build files in the repo, please change .gitignore so that it will ignore the whole folder or file
* When changing one part, please make sure no one else will get effected, if it is crucial let them know
* When working on parts where intersect with other works, please try to specify in the Trello's description field



## How to use the server
### Installation
1. Install django   
`pip install django==1.11`    

2. Install djano rest framework   
`pip install djangorestframework`   
`pip install markdown`    
`pip install django-filter`   

3. Install httpie - for test API    
`pip install --upgrade httpie`    
> You can also use curl to test it    
-----   

### Running
1. cd server/byteme   
run `python manage.py runserver`    

##### View Admin website
1. use browser, url: http://127.0.0.1:8000/admin/   
> account:  admin   
> password: password@   

##### Test the API

1. Browse API:
- Name: http://127.0.0.1:8000/api/v1/event/browse?type=   
- Method: GET   
- Description: Browse the events by user (created or attending) or all events    
- Parameters: type(String/required) value: attending or created or all          
- Example: http://127.0.0.1:8000/api/v1/event/browse?type=all                   
- Response:   
HTTP/1.0 200 OK
```
{
    "Response": "List_events",
    "Events": [
        {
            "identifier":"aebb68f1-b66e-4019-bde3-e4b09825850c",
            "creater":"Wuharlem",
            "attendant":["Wuharlem","Sting"],
            "abstract":"Superman is the best",
            "place":"Kaist",
            "time":"2018-11-03 03:01:00.914138+00:00",
            "title":"Superman",
            "details":"Blabla",
            "tags":["computer science  5.00"],
            "req":"mod",
            "speaker":{
                "univ":"KAIST",
                "dept":null,
                "tags":[],
                "name":"Harlem",
                "speakerEmail":"Harlem@email.com",
                "bio":null
            },
            "Iscore":69
        },
        {
            "identifier":"517a089c-d8eb-4551-b087-b47765ea04c8",
            "creater":"Wuharlem",
            "attendant":[],
            "abstract":"BlaBla",
            "place":"Kaist",
            "time":"2018-11-03 03:01:00.914138+00:00",
            "title":"Zombies",
            "details":"Blabla",
            "tags":[],
            "req":"non",
            "speaker":{
                "univ":"KAIST",
                "dept":null,
                "tags":[],
                "name":"Harlem",
                "speakerEmail":"Harlem@email.com",
                "bio":null
            },
            "Iscore":0
        }
    ]
}
```        
HTTP/1.0 400 Bad Request                
```
{       
    "Response": "Add_Event",        
    "status": reason 
}       
```

2. Add Event API:
- Name: http://127.0.0.1:8000/api/v1/event/add
- Method: POST
- Description: Request to add the event
- Request json interface:  
```
{    
    "Request": "Add_event",
    "Event": {      
        "abstract": "BlaBla",       
        "place": "Kaist",       
        "time": "2018-11-03 03:01:00.914138+00:00",         
        "title": "Zombies",         
        "details": "Blabla",
        "speaker": {
            "name": "Steve",
            "univ": "KAIST",
            "speakerEmail": "Steve@email.com"
        },
        "poster_image": "imageimage" 
    }       
}
```
- Response json interface:   
HTTP/1.0 202 Accepted  
```
{       
    "Events": {     
        "id": "51dca183-1dd7-4342-ae22-a10efe1d9d3f",       
        "status": "wait",       
        "title": "Zombies"      
    },      
    "Response": "Add_Event"     
}           
```
HTTP/1.0 400 Bad Request                
```
{       
    "Response": "Add_Event",        
    "status": "please check the response json"      
}       
```

3. Delete Event:       
- Name: http://127.0.0.1:8000/api/v1/event/delete/<event_id>
- Method: DELETE
- Description: Delete request to add/mod/del the event
- Parameters: event_id(UUID/required)       
- Example: http://127.0.0.1:8000/api/v1/event/delete/aa6634c6-b10c-4339-b2c4-3e4baf49880e               
- Response json interface:     
HTTP/1.0 202 Accepted  
```
{
    "Response":"Delete_event",
    "Event":{
        "id":"aa6634c6-b10c-4339-b2c4-3e4baf49880e",
        "title":"Superman",
        "status":"processing"}
    }
}
```

4. Modify Event:       
- Name: http://127.0.0.1:8000/api/v1/event/modify/<event_id>
- Method: DELETE
- Description: Delete request to add/mod/del the event
- Parameters: event_id(UUID/required)       
- Example: http://127.0.0.1:8000/api/v1/event/modify/aa6634c6-b10c-4339-b2c4-3e4baf49880e       
- Request json interface:  
```
{
    "Request": "Modify_event",
    "Event": {
        "abstract": "Superman is the best (optional)",
        "place": "Kaist (optional",
        "time": "2018-11-03 03:01:00.914138+00:00 (optional",         
        "title": "Superman (optional",         
        "details": "Blabla (optional",
        "poster_image": "imageimage (optional",
        "speaker": {
            "name": "Harlem",
            "univ": "KAIST",
            "speakerEmail": "Harlem@email.com"
        }
    }
}
```             
- Response json interface:     
HTTP/1.0 202 Accepted        
```
{
    "Response":"Modify_Event",
    "Events":{
        "id":"1f1eb026-78a3-4bc8-af81-0f21709efdfe",
        "title":"Zombies"
    },
    "status":"processing"
}
```

5. Approve Event request:       
- Name: http://127.0.0.1:8000/api/v1/event/request/approvel/<event_id>
- Method: POST
- Description: Request to delete the event      
- Parameters: event_id(UUID/required)  *need to use form to pass!!          
- Response json interface:        
```
HTTP/1.0 205 Reset Content  
{       
    "Response": "Delete_event",        
    "Event": {      
        "id": aa6634c6-b10c-4339-b2c4-3e4baf49880e,      
        "title": "Zombies",    // title only present in add and modify (not delete)
        "status": "wait"             
    }                   
}           
```

6. Sign Up request:
- Name: http://127.0.0.1:8000/api/v1/account/register
- Method: POST
- Description: Request to create an account
- Example: http://127.0.0.1:8000/api/v1/event/request/approvel/aa6634c6-b10c-4339-b2c4-3e4baf49880e               
- Request json interface:        
```
{
    "Request": "Sign_up",
    "User": {
        "id": "mustafa",
        "email": "myaldiz@kaist.ac.kr",
        "pw_hash": "XXA83jd3kljsdf",
        "type": "normal",   // or admin
    }
}
```
- Response json interface:        
```
{
    "Example_responses": [
        {
            "Response": "Sign_up",
            "id": "mustafa",
            "result": "accepted"
        }
    ]
}
```

7. Login request:
- Name: http://127.0.0.1:8000/api/v1/account/login/
- Name: http://127.0.0.1:8000/api/v1/account/logout/
- Method: GET
- Description: Request to login
- Parameter: idk
- Response json interface:        
```
idk
```

8. Modify profile request:
- Name: http://127.0.0.1:8000/api/v1/account/modify
- Method: POST
- Description: Request to modify department and tags for users              
- Request json interface:        
```
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
```
- Response json interface:        
```
{
    "Response": "Modify_profile",
    "status": "accepted"
}
```

9. Mark attend request:
- Name: http://127.0.0.1:8000/api/v1/event/attend/<event_id>
- Method: POST
- Description: Request to modify department and tags for users              
- Response json interface:        
```
{
    "Response":"Mark_event",
    "status":"accepted"
}
```

10. Unmark attend request:
- Name: http://127.0.0.1:8000/api/v1/event/unattend/<event_id>
- Method: POST
- Description: Request to modify department and tags for users              
- Response json interface:        
```
{
    "Response":"Unmark_event",
    "status":"accepted"
}
```

-----
### Model
If you change the code in the model, you need to run:   
`python manage.py makemigrations`   
`python manage.py migrate`    
    
this is for modifying the table in sqlite   


-----
### Node.js Test App        
`node test [username] [password] [command] [Event_ID] [req]`        

commands:
<pre>
every operations related to the events           
    browse?type=all             Browse all events
    browse?type=attending       Browse the events login user attending
    browse?type=created         Browse the events login user created
    add                         Add the event
    mod [Event_ID]              Modift the event with Event_ID
    del [Event_ID]              Delete the event with Event_ID
    approve [Event_ID] [req]    Approve the event request with Event_ID (only Admin)
    changetags [Event_ID]       change tags of event
    attend [Event_ID]           attend the event
    unattend [[Event_ID]]       unattend the event



every operations related to the accounts
    register                    add a new user 
    profile                     get profile
    updateprofile               modigy profile
<pre>

you can also modify the json interface of each request in the javascript code
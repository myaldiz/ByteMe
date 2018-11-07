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
- Name: http://127.0.0.1:8000/api/v1/event/browse   
- Method: GET   
- Description: Browse the events by user or all events    
- Parameters: User(String/optional)   
- Example:      
use httpe   
> http http://127.0.0.1:8000/api/v1/event/browse   
> http http://127.0.0.1:8000/api/v1/event/browse?user=Wuharlem   

2. Add Event API:
- Name: http POST http://127.0.0.1:8000/api/v1/event/add
- Method: POST
- Description: Request to add the event
- Request:  
{   
    add_event: {    
        "Request": "Add_event",     
        "User": {   
            "email": "user1@gmail.com", (required)        
            "pw_hash": "XXA83jd3kljsdf",    
            "ip": "143.248.143.29"  
        },      
        "speaker":{     
            "name": "Zombie"    (required)
        },      
        "Event": {      
            "abstract": "BlaBla",       
            "place": "Kaist",       
            "time": "2018-11-03 03:01:00.914138+00:00",         
            "title": "Zombies",         
            "details": "Blabla"     
        }       
    }       
}       

- Respond:      
HTTP/1.0 202 Accepted  
{       
    "Events": {     
        "id": "51dca183-1dd7-4342-ae22-a10efe1d9d3f",       
        "status": "wait",       
        "title": "Zombies"      
    },      
    "Response": "Add_Event"     
}           

HTTP/1.0 400 Bad Request                
{       
    "Response": "Add_Event",        
    "status": "please check response json"      
}       

- Example:      
use httpe   
> http POST http://127.0.0.1:8000/api/v1/event/add add_event:='{"Request": "Add_event", "User": {"email": "user1@gmail.com", "pw_hash": "XXA83jd3kljsdf", "ip": "143.248.143.29"}, "speaker":{"name": "Zombie"}, "Event": { "abstract": "BlaBla", "place": "Kaist", "time": "2018-11-03 03:01:00.914138+00:00", "title": "Zombies", "details": "Blabla"}}'  

3. Approve Event request:       
- Name: http -f POST http://127.0.0.1:8000/api/v1/event/request/approvel/<event_id>
- Method: POST
- Description: Request to delete the event
- Parameters: event_id(UUID/required) 
- Response:     
HTTP/1.0 205 Reset Content  
{       
    "Response": "Delete_event",        
    "Event": {      
        "id": 123,      
        "title": "Zombies",     
        "status": "wait"             
    }                   
}           

- Example:            
use httpe             
> http DELETE http://127.0.0.1:8000/api/v1/event/delete/<event_id> 

4. Delete Event:       
- Name: http DELETE http://127.0.0.1:8000/api/v1/event/delete/<event_id>
- Method: POST
- Description: Delete request to add/mod/del the event
- Parameters: event_id(UUID/required) 
- Request:          
{
    req: add | del | mod
}

- Response:     
HTTP/1.0 205 Reset Content  
{       
    "Response": "Add_event",        
    "Event": {      
        "id": 123,      
        "title": "Zombies",     
        "status": "accepted"        
    }           
}


- Example:      
use httpe       
> http -f POST http://127.0.0.1:8000/api/v1/event/request/approvel/<event_id> req="add"


-----
### Model
If you change the code in the model, you need to run:   
`python manage.py makemigrations`   
`python manage.py migrate`    
    
this is for modifying the table in sqlite   

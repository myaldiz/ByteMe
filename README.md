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
> http://127.0.0.1:8000/api/v1/event/browse   
> http://127.0.0.1:8000/api/v1/event/browse?user=Wuharlem   

-----
### Model
If you change the code in the model, you need to run:   
`python manage.py makemigrations`   
`python manage.py migrate`    
    
this is for modifying the table in sqlite   

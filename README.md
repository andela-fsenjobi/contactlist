#Contactlist API [![Code Climate](https://codeclimate.com/github/andela-fsenjobi/contactlist/badges/gpa.svg)](https://codeclimate.com/github/andela-fsenjobi/contactlist) [![Coverage Status](https://coveralls.io/repos/github/andela-fsenjobi/contactlist/badge.svg?branch=master)](https://coveralls.io/github/andela-fsenjobi/contactlist?branch=master) [![Circle CI](https://circleci.com/gh/andela-fsenjobi/contactlist.svg?style=svg)](https://circleci.com/gh/andela-fsenjobi/contactlist)
I have a small business I run and I have been looking at ways to use technology to make record keeping easy for myself. As soon as the opprtunity to create an API came, the very first thing on my mind was a contact list.
##Here is some Background
I sell data to mobile phone users and in a month I have over 100 transactions. That means over a period of one year, I have well over 1200 transactions to organize. Sometimes, all I have is a name. Other times, all I have is a number. I'd have to look through my records to find the missing part of the puzzle. And most importantly, I need to know the expiry date for some subscriptions.

Building this API will certainly make things easier. I can just make queries and get exactly what I want. And as time progresses, I'll develop a front end to give it a beffiting User Interface.

##Getting Started
###Setting things up on your Local Machine

* Clone the application with `git clone git https://github.com/andela-fsenjobi/contactlist.git`
* Navigate into the the `contactlist` folder and run `bundle install`
* Setup the database with `rake db:migrate` (Also run `rake db:seed` if you want to use the seed data.)
* Run `rails s` and you can begin to use the API endpoints

###Available Endpoints
| Methods   |      Endpoints      |  Params        | Secured |
|-----------|---------------------|----------------------|-------|
| POST      | /api/users          | email, password      | false |
| GET       | /api/users/id       | none                 | true  |
| PATCH/PUT | /api/users/id       | email, password      | true  |
| DELETE    | /api/users/id       | none                 | true  |
| POST      | /api/auth/login     | email, password      | false |
| GET       | /api/auth/logout    | none                 | true  |
| POST      | /api/customers      | name, phone, referer | true  |
| GET       | /api/customers/id   | none | true |
| GET       | /api/customers/  | none | true |
| PATH/PUT  | /api/customers/id   | name, phone, referer | true |
| DELETE    | /api/customers/id   | none | true |
| GET       | /api/customers/id   | none | true |
| POST      | /api/customers/id/transactions      | amount, expiry, status | true  |
| GET      | /api/transactions      | none | true  |
| GET       | /api/customers/id/transactions   | none | true |
| GET       | /api/customers/id/transactions/id | none | true |
| PATH/PUT  | /api/customers/id/transactions/id   | amount, expiry, status | true |
| DELETE    | /api/customers/id/transactions/id   | none | true |
| GET       | /api/stats/total  | none | true |
| GET       | /api/stats/month    | none | true |
| GET       | /api/stats/customers    | none | true |
###Using the API
####Users:
#####Creating a User
>**Method:** POST
>
>**Parameters:** email, password
>
>`curl -X POST "https://my-contactlist.herokuapp.com/api/users?email=my@email.com&password=1qw23er45t"`

#####Updating a User
>**Method:** PATCH
>
>**Parameters:** email, password
>
>**Headers:** Authorization: 1qasw23EDF4RFF55tsgyeyey.u3uhdjjueu8ueueu89 (Token from login)
>
>`curl -X PATCH -H "Authorization: 1qasw23EDF4RFF55tsgyeyey.u3uhdjjueu8ueueu89" "https://my-contactlist.herokuapp.com/api/users/1/?email=my@email.com&password=1qw23er45t"`
>
>**NB:** You will have to login again after updating the user details

#####Viewing a User
>**Method:** GET
>
>**Headers:** Authorization: 1qasw23EDF4RFF55tsgyeyey.u3uhdjjueu8ueueu89 (Token from login)
>
>`curl -X GET -H "Authorization: 1qasw23EDF4RFF55tsgyeyey.u3uhdjjueu8ueueu89" "https://my-contactlist.herokuapp.com/api/users/1/`
>
>**NB:** You will have to login again after updating the user details

#####Deleting a User
>**Method:** DELETE
>
>**Headers:** Authorization: 1qasw23EDF4RFF55tsgyeyey.u3uhdjjueu8ueueu89 (Token from login)
>
>`curl -X DELETE -H "Authorization: 1qasw23EDF4RFF55tsgyeyey.u3uhdjjueu8ueueu89" "https://my-contactlist.herokuapp.com/api/users/1/`
>
>**NB:** You will have to login again after updating the user details

####Authentication:
#####Logging in a User
>**Method:** POST
>
>`curl -X POST "https://my-contactlist.herokuapp.com/api/users/?email=my@email.com&password=1qw23er45t`

#####Logging out a User
>**Method:** GET
>
>**Headers:** Authorization: 1qasw23EDF4RFF55tsgyeyey.u3uhdjjueu8ueueu89 (Token from login)
>
>`curl -X GET -H "Authorization: 1qasw23EDF4RFF55tsgyeyey.u3uhdjjueu8ueueu89" "https://my-contactlist.herokuapp.com/api/users/1/`

####Customers:
You will be able to do the following:

* Creating a Customer
* Updating a Customer
* Viewing a Customer
* Deleting a Customer
* Creating a Customer


####Transactions:
You will be able to do any of the following

* Creating a Transaction
* Updating a Transaction
* Viewing a Transaction
* Deleting a Transaction
* Creating a Transaction


####Other Features
* Pagination: Users can specify page number and number of records per page. The first page is returned by default and the number of records per page is 20. You can do this by appending either or both of `&page=2` and `&limit=30` to return the second page or return 30 records per page. E.g:
 > `curl -X GET "https://my-contactlist.herokuapp.com/api/customers/?page=2&limit=15`

* Search: Users will be able to search customers by name or phone number. `q=Femi` will return customers whose name or number is `like` 'Femi'
 > `curl -X GET "https://my-contactlist.herokuapp.com/api/customers/?q=Femi`

* Stats: The API also offers features

	* Total Stats `/stats/total`: Here we can view total number of customers, number of transactions and total profit.
	* Month's Stats `/stats/month`: Here we can see number of customers added in the month, number os transactions and month's profit.
	* Customer Stats `/stats/customers`: (helps to see most frequest customers.

###Dependencies
A complete list of dependencies can be found in the `Gemfile`
###Testing
This API comes fully tested! You can run the tests with `rspec`
###API Features
* Create, Read, Update and Delete Users
* Authenticate (Login and Logout) Users
* Create, Read, Update and Delete Customers
* Create, Read, Update and Delete Customers' transactions

###Live Demonstration
[See Contactlist on Heroku](https://my-contactlist.herokuapp.com)

###Contributing to Contactlist
You may make modifications and improvements on the application with the following procedures

* Fork the repository
* Make your additions
* Create a pull request

The modifications will be reviewed and merged if necessary. Properly tested modifications will be given priority

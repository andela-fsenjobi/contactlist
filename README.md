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

###Using the API
####Users:
#####Creating a User
>**Method:** POST
>
>**Parameters:** user[email], user[password]
>
>`curl -X POST "http://localhost:3000/api/users?user[email]=my@email.com&user[password]=1qw23er45t"`

#####Updating a User
>**Method:** PATCH
>
>**Parameters:** user[email], user[password]
>
>**Headers:** Authorization: 1qasw23EDF4RFF55tsgyeyey.u3uhdjjueu8ueueu89 (Token from login)
>
>`curl -X PATCH -H "Authorization: 1qasw23EDF4RFF55tsgyeyey.u3uhdjjueu8ueueu89" "http://localhost:3000/api/users/1/?user[email]=my@email.com&user[password]=1qw23er45t"`
>
>**NB:** You will have to login again after updating the user details

#####Viewing a User
>**Method:** GET
>
>**Headers:** Authorization: 1qasw23EDF4RFF55tsgyeyey.u3uhdjjueu8ueueu89 (Token from login)
>
>`curl -X GET -H "Authorization: 1qasw23EDF4RFF55tsgyeyey.u3uhdjjueu8ueueu89" "http://localhost:3000/api/users/1/`
>
>**NB:** You will have to login again after updating the user details

#####Deleting a User
>**Method:** DELETE
>
>**Headers:** Authorization: 1qasw23EDF4RFF55tsgyeyey.u3uhdjjueu8ueueu89 (Token from login)
>
>`curl -X DELETE -H "Authorization: 1qasw23EDF4RFF55tsgyeyey.u3uhdjjueu8ueueu89" "http://localhost:3000/api/users/1/`
>
>**NB:** You will have to login again after updating the user details

####Authentication:
#####Logging in a User
>**Method:** POST
>
>`curl -X POST "http://localhost:3000/api/users/?session[email]=my@email.com&session[password]=1qw23er45t`

#####Logging out a User
>**Method:** GET
>
>**Headers:** Authorization: 1qasw23EDF4RFF55tsgyeyey.u3uhdjjueu8ueueu89 (Token from login)
>
>`curl -X GET -H "Authorization: 1qasw23EDF4RFF55tsgyeyey.u3uhdjjueu8ueueu89" "http://localhost:3000/api/users/1/`

####Customers:
#####Creating a Customer
#####Updating a Customer
#####Viewing a Customer
#####Deleting a Customer
#####Creating a Customer
####Transactions:
#####Creating a Transaction
#####Updating a Transaction
#####Viewing a Transaction
#####Deleting a Transaction
#####Creating a Transaction
####Other Features
#####Pagination
#####Most Active Customers
#####Passive Customers

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
This API is hosted at: `*herokuapp.com`

###Contributing to Contactlist
You may make modifications and improvements on the application with the following procedures

* Fork the repository
* Make your additions
* Create a pull request

The modifications will be reviewed and merged if necessary. Properly tested modifications will be given priority

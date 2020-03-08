# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################

# Database schema - this should reflect your domain model
DB.create_table! :courses do
  primary_key :id
  String :name
  String :location
  String :rate
  Boolean :range?
end
DB.create_table! :reviews do
  primary_key :id
  foreign_key :courses_id
  Boolean :recommend
  String :name
  String :email
  String :comments, text: true
  Boolean :check_in 
end

# Insert initial (seed) data
courses_table = DB.from(:courses)

courses_table.insert(name: "Cog Hill Dubsdread", 
                    location: "Lemont, IL",
                    rate: "$200",
                    range?: "1")

courses_table.insert(name: "ThunderHawk", 
                    location: "Beach Park, IL",
                    rate: "$90",
                    range?: "1")
courses_table.insert(name: "The Glen Club", 
                    location: "Glenview, IL",
                    rate: "$165",
                    range?: "1")                   
courses_table.insert(name: "Harborside International Golf Center", 
                    location: "Chicago, IL",
                    rate: "$90",
                    range?: "1")
courses_table.insert(name: "Ruffled Feathers", 
                    location: "Chicago, IL",
                    rate: "$90",
                    range?: "1")
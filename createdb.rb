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
  String :phone
  String :rate
  String :range
end

DB.create_table! :reviews do
  primary_key :id
  foreign_key :courses_id
  Boolean :recommend
  String :name
  String :comments, text: true
end

# Insert initial (seed) data
courses_table = DB.from(:courses)

courses_table.insert(name: "Cog Hill - Dubsdread", 
                    location: "Lemont, IL",
                    phone: "(866) 264-4455",
                    rate: "Average Rate: $200",
                    range: "Range?: Yes")

courses_table.insert(name: "ThunderHawk", 
                    location: "Beach Park, IL",
                    phone: "(847) 968-4295",
                    rate: "Average Rate: $90",
                    range: "Range?: Yes")
courses_table.insert(name: "The Glen Club", 
                    location: "Glenview, IL",
                    phone: "(847) 724-7272",
                    rate: "Average Rate: $165",
                    range: "Range?: Yes")                  
courses_table.insert(name: "Harborside International Golf Center", 
                    location: "Chicago, IL",
                    phone: "312) 782-7837",
                    rate: "Average Rate: $90",
                    range: "Range?: Yes")
courses_table.insert(name: "Ruffled Feathers", 
                    location: "Chicago, IL",
                    phone: "(630) 257-1000",
                    rate: "Average Rate: $90",
                    range: "Range?: Yes")
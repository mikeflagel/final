# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################

DB.create_table! :courses do
  primary_key :id
  String :title
  String :location
  String :phone
  String :website
  String :rate
  String :range

end

DB.create_table! :reviews do
  primary_key :id
  foreign_key :course_id
  foreign_key :user_id
  Boolean :recommend
  String :comments, text: true
end

DB.create_table! :users do
  primary_key :id
  String :name
  String :email
  String :password
end

courses_table = DB.from(:courses)

courses_table.insert(title: "Cog Hill - Dubsdread", 
                    location: "Lemont, IL",
                    phone: "(866) 264-4455",
                    website: "https://www.coghillgolf.com/",
                    rate: "Average Rate: $200",
                    range: "Range?: Yes")

courses_table.insert(title: "ThunderHawk", 
                    location: "Beach Park, IL",
                    phone: "(847) 968-4295",
                    website: "http://www.thunderhawkgolfclub.org/",
                    rate: "Average Rate: $90",
                    range: "Range?: Yes")
courses_table.insert(title: "The Glen Club", 
                    location: "Glenview, IL",
                    phone: "(847) 724-7272",
                    website: "https://www.theglenclub.com/",
                    rate: "Average Rate: $165",
                    range: "Range?: Yes")                  
courses_table.insert(title: "Harborside International Golf Center", 
                    location: "Chicago, IL",
                    phone: "312) 782-7837",
                    website: "https://www.harborsidegolf.com/",
                    rate: "Average Rate: $90",
                    range: "Range?: Yes")
courses_table.insert(title: "Ruffled Feathers", 
                    location: "Chicago, IL",
                    phone: "(630) 257-1000",
                    website: "https://www.ruffledfeathersgc.com/",
                    rate: "Average Rate: $90",
                    range: "Range?: Yes")
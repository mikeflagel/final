# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "bcrypt"     
require "geocoder"  
                                                               #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################

courses_table = DB.from(:courses)
reviews_table = DB.from(:reviews)

get "/" do
    puts "params: #{params}"

    pp courses_table.all.to_a
    @courses = courses_table.all.to_a
    view "courses"
end

get "/courses/:id" do
    puts "params: #{params}"

    pp courses_table.where(id: params[:id]).to_a[0]
    @course = courses_table.where(id: params[:id]).to_a[0]
   

    view "course"
end

get "/courses/:id/reviews/new" do
    puts "params: #{params}"

    @course = courses_table.where(id: params[:id]).to_a[0]
    view "new_review"
end

post "/courses/:id/reviews/create" do
    puts "params: #{params}"

    @course = courses_table.where(id: params[:id]).to_a[0]
    reviews_table.insert(
        course_id: @course[:id],
        name: session["name"],
        comments: params["comments"],
        going: params["going"]
    )
    view "create_review"
end

get "/reviews/:id/edit" do
    puts "params: #{params}"

    @review = reviews_table.where(id: params["id"]).to_a[0]
    @course = courses_table.where(id: @review[:course_id]).to_a[0]
    view "edit_review"
end

post "/reviews/:id/update" do
    puts "params: #{params}"

    view "update_review"
end

get "/reviews/:id/destroy" do
    puts "params: #{params}"

    review = reviews_table.where(id: params["id"]).to_a[0]
    @course = reviews_table.where(id: rsvp[:event_id]).to_a[0]

    reviews_table.where(id: params["id"]).delete

    view "destroy_review"
end

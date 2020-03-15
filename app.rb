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
users_table = DB.from(:users)

before do
    @current_user = users_table.where(id: session["user_id"]).to_a[0]
end

get "/" do
    puts "params: #{params}"

    @courses = courses_table.all.to_a
    pp @courses

    view "courses"
end

get "/courses/:id" do
    puts "params: #{params}"

    @users_table = users_table
    @course = courses_table.where(id: params[:id]).to_a[0]
    pp @course

    @reviews = reviews_table.where(course_id: @course[:id]).to_a
    @recommend_count = reviews_table.where(course_id: @course[:id], recommend: true).count

    @lat = rand(-90.0..90.0)
    @long = rand(-180.0..180.0)
    @lat_long = "#{@lat},#{@long}"

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
        user_id: session["user_id"],
        comments: params["comments"],
        recommend: params["recommend"]
    )

    redirect "/courses/#{@course[:id]}"
end

get "/reviews/:id/edit" do
    puts "params: #{params}"

    @review = reviews_table.where(id: params["id"]).to_a[0]
    @course = courses_table.where(id: @review[:course_id]).to_a[0]
    view "edit_review"
end

post "/reviews/:id/update" do
    puts "params: #{params}"

    @review = reviews_table.where(id: params["id"]).to_a[0]

    @course = courses_table.where(id: @review[:course_id]).to_a[0]

    if @current_user && @current_user[:id] == @review[:id]
        reviews_table.where(id: params["id"]).update(
            recommend: params["recommend"],
            comments: params["comments"]
        )

        redirect "/courses/#{@course[:id]}"
    else
        view "error"
    end
end


get "/reviews/:id/destroy" do
    puts "params: #{params}"

    review = reviews_table.where(id: params["id"]).to_a[0]
    @course = courses_table.where(id: rsvp[:event_id]).to_a[0]

    reviews_table.where(id: params["id"]).delete

    redirect "/courses/#{@course[:id]}"
end


get "/users/new" do
    view "new_user"
end


post "/users/create" do
    puts "params: #{params}"

    existing_user = users_table.where(email: params["email"]).to_a[0]
    
    if existing_user
        view "error"
    else
        users_table.insert(
            name: params["name"],
            email: params["email"],
            password: BCrypt::Password.create(params["password"])
        )

        redirect "/logins/new"
    end
end


get "/logins/new" do
    view "new_login"
end


post "/logins/create" do
    puts "params: #{params}"

    @user = users_table.where(email: params["email"]).to_a[0]

    if @user
        if BCrypt::Password.new(@user[:password]) == params["password"]
            
            session["user_id"] = @user[:id]
            redirect "/"
        else
            view "create_login_failed"
        end
    else
        view "create_login_failed"
    end
end

get "/logout" do
    session["user_id"] = nil
    redirect "/logins/new"
end
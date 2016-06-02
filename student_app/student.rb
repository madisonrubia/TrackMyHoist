require 'dm-core'
require 'dm-migrations'

class Student
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :email, String
end

configure do
  enable :sessions
  set :username, 'mrubia'
  set :password, 'lola'
end

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

DataMapper.finalize

get '/students' do
  @students = Student.all
  erb :students
end

get '/students/new' do
  halt(401, 'Not Authorized') unless session[:admin]
  @student = Student.new
  erb :new_student
end

get '/students/:id' do
  @student = Student.get(params[:id])
  puts 'hello'
  erb :show_student
end

get '/students/:id/edit' do
  halt(401, 'Not Authorized') unless session[:admin]
  @student = Student.get(params[:id])
  erb :edit_student
end

post '/students' do
  student = Student.create(params[:student])
  redirect to("/students/#{student.id}")
end

put '/students/:id' do
  student = Student.get(params[:id])
  student.update(params[:student])
  redirect to("/students/#{student.id}")
end

delete '/students/:id' do
  Student.get(params[:id]).destroy
  redirect to('/students')
end

post '/login' do
  if params[:username] == settings.username && params[:password] == settings.password
    session[:admin] = true
    redirect to ('/students')
  else
    erb :login
  end
end

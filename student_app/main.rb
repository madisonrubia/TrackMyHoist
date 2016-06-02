require 'sinatra'
require 'erb'
require 'dm-sqlite-adapter'
require './student'

configure do
  enable :sessions
  set :username, 'mrubia'
  set :password, 'lola'
end

get('/styles.scss'){ scss :styles } 

get '/' do
  erb :home
end

get '/about' do
  @title = "All About This Website"
  erb :about
end 

get '/contact' do
  erb :contact
end

get '/login' do
  erb :login
end

get '/logout' do
  session.clear
  redirect to('/login')
end

not_found do
  erb :not_found
end

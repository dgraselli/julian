#let Bundler handle all requires
require 'bundler'
Bundler.require(:default)

#julian2015
#APP_ID = 635457879887599
#APP_SECRET = 'c41e31decaab2f5226961f65f567e8e9'

#chaca
APP_ID = 1594605847423709
APP_SECRET = '6c6594b1ec81d27846636ca322b68844'


require "sinatra/activerecord"
set :database, {adapter: "sqlite3", database: "db/base.sqlite3"}


class SimpleApp < Sinatra::Application

  register Sinatra::ActiveRecordExtension

  use Rack::Session::Cookie, secret: 'PUT_A_GOOD_SECRET_IN_HERE'

  #@data_aux = JSON.parse(File.read 'public/dat.json')

get '/' do
    if session['access_token']
      @graph = Koala::Facebook::API.new(session['access_token'])
      @profile = @graph.get_object("me")
      @friends = @graph.get_connections("me", "friends")

      @data = JSON.parse(File.read 'public/dat.json')

      erb :inicio
    # do some stuff with facebook here
    # for example:
  # @graph = Koala::Facebook::GraphAPI.new(session["access_token"])
  # publish to your wall (if you have the permissions)
  # @graph.put_wall_post("I'm posting from my new cool app!")
  # or publish to someone else (if you have the permissions too ;) )
  # @graph.put_wall_post("Checkout my new cool app!", {}, "someoneelse's id")

  else
    redirect '/login'
  end
end

get '/login' do
  # generate a new oauth object with your app data and your callback url
  session['oauth'] = Koala::Facebook::OAuth.new(APP_ID, APP_SECRET, "#{request.base_url}/callback")
  # redirect to facebook to get your code
  redirect session['oauth'].url_for_oauth_code(:permissions => "user_friends, user_relationships, publish_actions")
end

get '/logout' do
  session['oauth'] = nil
  session['access_token'] = nil
  redirect '/'
end

get '/callback' do
  #get the access token from facebook with your code
  session['access_token'] = session['oauth'].get_access_token(params[:code])
  redirect '/'
end

get  '/paso1' do
  selected = params['selected'].split(',')
  @data = JSON.parse(File.read 'public/dat.json').select{|d| selected.include? d['id']}
  erb :paso1
end

get  '/paso2' do
  selected = params['selected'].split(',')
  @data_aux = JSON.parse(File.read 'public/dat.json').select{|d| selected.include? d['id']}
  @data = []
  selected.each do |d|
    a = @data_aux.select{|x| x['id'] == d }
    p a
    @data << a[0]
  end

  p @data
  erb :paso2
end

class Persona < ActiveRecord::Base
end
class TemasSeleccionado < ActiveRecord::Base
end

get  '/paso3' do
  selected = params['selected'].split(',')
  @data = JSON.parse(File.read 'public/dat.json').select{|d| selected.include? d['id']}

  @graph = Koala::Facebook::API.new(session['access_token'])
  @profile = @graph.get_object("me")
  @graph.put_wall_post("Test posting 2 from ext app!")

  Persona.create({
    login: @profile['id'],
    name: @profile['name'],
    })

  idx = 1;
  selected.each do |x|
    TemasSeleccionado.create(
      {
      login: @profile['id'],
      tema: x,
      orden: idx
      })
    idx += 1
  end


  erb :paso3
end

end

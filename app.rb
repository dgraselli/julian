#let Bundler handle all requires
require 'bundler'
Bundler.require(:default)

#julian2015
#APP_ID = 635457879887599
#APP_SECRET = 'c41e31decaab2f5226961f65f567e8e9'

#chaca
APP_ID = 1594605847423709
APP_SECRET = '6c6594b1ec81d27846636ca322b68844'

class SimpleRubyFacebookExample < Sinatra::Application
use Rack::Session::Cookie, secret: 'PUT_A_GOOD_SECRET_IN_HERE'
get '/' do
if session['access_token']
'You are logged in! <a href="/logout">Logout</a>'
# do some stuff with facebook here
# for example:
# @graph = Koala::Facebook::GraphAPI.new(session["access_token"])
# publish to your wall (if you have the permissions)
# @graph.put_wall_post("I'm posting from my new cool app!")
# or publish to someone else (if you have the permissions too ;) )
# @graph.put_wall_post("Checkout my new cool app!", {}, "someoneelse's id")
else
'<a href="/login">Login</a>'
end
end
get '/login' do
# generate a new oauth object with your app data and your callback url
session['oauth'] = Koala::Facebook::OAuth.new(APP_ID, APP_SECRET, "#{request.base_url}/callback")
# redirect to facebook to get your code
redirect session['oauth'].url_for_oauth_code()
end
get '/logout' do
session['oauth'] = nil
session['access_token'] = nil
redirect '/'
end
#method to handle the redirect from facebook back to you
get '/callback' do
#get the access token from facebook with your code
session['access_token'] = session['oauth'].get_access_token(params[:code])
redirect '/'
end

get  '/inicio' do
  @data = JSON.parse(File.read 'public/dat.json')
  erb :inicio
end

get  '/paso1' do
  @data = JSON.parse(File.read 'public/dat.json')
  erb :paso1
end

end

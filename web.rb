$:.unshift "."

require 'sinatra'
require 'rdio'

before do
  @rdio = Rdio.new ENV["RDIO_API_KEY"], ENV["RDIO_API_SHARED_SECRET"]
end

get '/' do
  'try /[username]/[API method]'
end

get '/user/:name' do |name|
  content_type 'application/json', :charset => 'utf-8'
  cache_control :public, :max_age => 60*60

  callback = params.delete('callback')
  json = (@rdio.findUser vanityName: name).to_json

  if callback
    content_type :js
    response = "#{callback}(#{json})" 
  else
    content_type :json
    response = json
  end

  response
end

get '/:name/:method' do |name, method|
  content_type 'application/json', :charset => 'utf-8'
  cache_control :public, :max_age => 60*60

  callback = params.delete('callback')
  user = @rdio.findUser vanityName: name

  json = @rdio.send(method.to_sym, user: user['key'], limit: 25).to_json

  if callback
    content_type :js
    response = "#{callback}(#{json})" 
  else
    content_type :json
    response = json
  end

  response
end
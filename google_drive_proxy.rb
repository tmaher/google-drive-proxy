require 'sinatra/base'

# hello, world
class GoogleDriveProxy < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :sessions, true

  get '/' do
    'howdy there'
  end

  get '/foo' do
    'It is foo'
  end
end

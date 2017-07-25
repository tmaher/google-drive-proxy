require 'sinatra/base'
require 'sinatra/streaming'
require 'drive_proxy'

# hello, world
class GoogleDriveProxy < Sinatra::Base
  helpers Sinatra::Streaming

  set :root, File.dirname(__FILE__)
  set :sessions, true

  get '/' do
    'howdy there'
  end

  get '/foo' do
    'It is foo'
  end

  get '/gd/:id' do
    content_type 'application/octet-stream'
    stream do |out|
      DriveProxy.new(params[:id], io: out).render_target
    end
  end
end

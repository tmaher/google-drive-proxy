require 'sinatra/base'
#require 'sinatra/streaming'
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

  get '/foo/:id' do
    proxy = DriveProxy.new(params[:id])
    "DATA\n#{proxy.data}\n"
    #"over size limit: #{proxy.csrf?}\n"
    #proxy.download_url
    #resp = HTTParty.get("#{base_url}&id=#{params[:id]}")
    #{}"foo has ID thinger #{params[:id]}, resp #{resp}\n"
  end

  get '/gd/:id' do
    content_type 'application/octet-stream'
    stream do |out|
      DriveProxy.new(params[:id], io: out).data
    end
  end
end

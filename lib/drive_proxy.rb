require 'httparty_with_cookies'

# get stuff from gdrive with httparty!
class DriveProxy
  include HTTParty_with_cookies

  base_uri "https://drive.google.com"

  def small_download_url
    "/uc?export=download&id=#{@id}"
  end

  def initialize(object_id, io: nil)
    @id = object_id
    @io = io
    @response = get small_download_url, follow_redirects: true
    @token = csrf_token
  end

  def csrf?
    !@token.nil?
  end

  def csrf_token
    return nil if cookies.nil?
    @token ||= begin
      tok = nil
      cookies.each { |k,v| tok = v if k.start_with?('download_warning') }
      tok
    end
  end

  def data
    if csrf?
      large_url = "#{small_download_url}&confirm=#{csrf_token}"
      puts "large url #{large_url}"
      get(large_url, follow_redirects: true, stream_body: true) do |frag|
        @io.write frag
      end

    else
      @io << @response.body
    end

    #"OVER LIMIT - NOT IMPLEMENTED - cookies #{cookies}"
  end
end

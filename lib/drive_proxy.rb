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

  def chase_redirects(url = small_download_url)
    while url
      resp = head(url, follow_redirects: false)
      break if resp.code < 300
      return url if resp.code < 300
      url = resp.code >= 300 && resp.code < 400 ? resp.headers.location : nil
    end
    url
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
      resp = head(large_url, follow_redirects: false)
      puts "code: #{resp.code}"
      puts "headers: #{resp.headers}"
      puts "large url #{large_url}"
      codes = {}
      get(large_url, follow_redirects: true, stream_body: true) do |frag|
        @io.write frag
      end
      puts "codes: #{codes}"
    else
      @io << @response.body
    end

    #"OVER LIMIT - NOT IMPLEMENTED - cookies #{cookies}"
  end
end

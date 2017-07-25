require 'httparty_with_cookies'

# get stuff from gdrive with httparty!
class DriveProxy
  include HTTParty_with_cookies

  base_uri "https://drive.google.com"

  def unconfirmed_url
    "/uc?export=download&id=#{@id}"
  end

  def initialize(object_id, io: nil)
    @id = object_id
    @io = io
    @token = check_csrf_token
    @target_url = chase_redirects
  end

  def chase_redirects(url = confirmed_url)
    while url
      resp = head(url, follow_redirects: false)
      #puts "HEAD #{url}, code #{resp.code}"
      puts "code: #{resp.code}, class #{resp.code.class}, headers #{resp.headers['location']}"
      break if resp.code < 300 || resp.code >= 500
      return url if resp.code < 300
      url = if resp.code >= 300 && resp.code < 400
        resp.headers['location']
      else
        nil
      end
      #url = resp.code >= 300 && resp.code < 400 ? resp.headers['location'] : nil
    end
    url
  end

  def csrf?
    !@token.nil?
  end

  def check_csrf_token
    head(unconfirmed_url, follow_redirects: false) # get cookies
    @token ||= begin
      tok = nil
      unless cookies.nil?
        cookies.each { |k,v| tok = v if k.start_with?('download_warning') }
      end
      tok
    end
  end

  def confirmed_url
    @confirmed_url ||= unconfirmed_url + (csrf? ? "&confirm=#{@token}" : "")
  end

  def render_target
    get(@target_url, follow_redirects: false, stream_body: true) do |frag|
      @io.write frag
    end
  end

  def xxx
    if csrf?
      large_url = "#{small_download_url}&confirm=#{@token}"
      #resp = head(large_url, follow_redirects: false)
      #puts "code: #{resp.code}"
      #puts "headers: #{resp.headers}"
      #puts "large url #{large_url}"
      get(large_url, follow_redirects: true, stream_body: true) do |frag|
        @io.write frag
      end
    else
      @io << @response.body
    end
  end
end

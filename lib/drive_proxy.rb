require 'httparty_with_cookies'

# get stuff from gdrive with httparty!
class DriveProxy
  include HTTParty_with_cookies

  base_uri "https://drive.google.com"

  def small_download_url
    "/uc?export=download&id=#{@id}"
  end

  def initialize(object_id)
    @id = object_id
    @response |= get small_download_url, follow_redirects: true
  end

  def csrf?
    !cookies.nil?
  end

  def csrf_token
    return nil unless csrf?
    cookies.each { |k,v| return v if k.start_with?('download_warning') }
  end

  def data
    return @response.body unless csrf?

    #"OVER LIMIT - NOT IMPLEMENTED - cookies #{cookies}"
    csrf_token
  end
end

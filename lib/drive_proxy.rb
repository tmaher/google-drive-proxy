require 'httparty_with_cookies'

# get stuff from gdrive with httparty!
class DriveProxy
  include HTTParty_with_cookies

  BASE_URL = "https://drive.google.com/uc?export=download".freeze

  def initialize(object_id)
    @id = object_id
  end

  def download_url
    "#{BASE_URL}&id=#{@id}"
  end

  def some_cookies
    get(download_url)
    cookies
  end
end

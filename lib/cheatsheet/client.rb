module Cheatsheet
  class Client

    SOURCE = "https://raw.githubusercontent.com/rstacruz/cheatsheets/master/"

    def self.start(sheet_name)
      begin
        self.render self.fetch sheet_name
      rescue CheatSheetClientException => e
        self.render e
      end
    end

    def self.fetch(sheet_name)
      uri = URI(SOURCE + sheet_name + ".md")

      return self.fetch_raw(uri)
    end

    def self.fetch_raw(uri)
      response = Net::HTTP.get_response(uri)

      case response
      when Net::HTTPSuccess then
        Net::HTTP.get(uri)
      when Net::HTTPNotFound then
        raise CheatSheetClientException.new "We don't have that cheatsheet yet. Feel free to contribute here: https://github.com/rstacruz/cheatsheets"
      else
        response.value
      end
    end

    def self.render(string)
      puts string
    end

  end
end

class CheatSheetClientException < Exception
end

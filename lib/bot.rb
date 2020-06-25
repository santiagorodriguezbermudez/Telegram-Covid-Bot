require 'telegram/bot'
require_relative 'covid_api'

class Bot
  attr_reader :commands
  def initialize(token) 
    @token = token
    start_telegram_api(token)
  end

  private
  def start_telegram_api(token)
    covid_api = CovidApi.new

    Telegram::Bot::Client.run(token) do |bot|
      bot.listen do |message|
        case message.text
        when '/start'
          bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}.")
          bot.api.send_message(chat_id: message.chat.id, text: "This is the latest update on Covid for #{Date.today.strftime('%a, %-d %b of %Y:')}")
          
          summary_hash = covid_api.summary
          text_output = ''
          summary_hash.each do |key, value|
            value = value.to_s.reverse.scan(/\d{1,3}/).join(',').reverse
            key = key.split(/(?=[A-Z])/).join(' ')
            text_output += "#{key}: #{value}\n"
          end
          bot.api.send_message(chat_id: message.chat.id, text: text_output)
          
          countries_hash = covid_api.countries
          p countries_hash

          bot.api.send_message(chat_id: message.chat.id, text: "Please type one of the following countries to get information: ")
        end
      end
    end
  end

  def reply(input)
    
  
  end
end




require 'telegram/bot'
require 'geocoder'
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
        case message
          when Telegram::Bot::Types::Message
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
              
              #Provides the user with the current options
              kb = [
                Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Latest news on Covid', url: 'https://google.com'),
                Telegram::Bot::Types::InlineKeyboardButton.new(text: 'What is the situation in my country?', callback_data: 'location'),
                Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Select a specific country', callback_data: 'country')
              ]
              markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
              bot.api.send_message(chat_id: message.chat.id, text: 'What else do you want to know', reply_markup: markup)
            end

            # If there is a location, numbers will be fiven. 
            if message.location
              location = Geocoder.search([message.location.latitude, message.location.longitude])
              country = covid_api.country(location.first.country)
              text_output = ''
              country.each do |key, value|
                value = value.to_s.reverse.scan(/\d{1,3}/).join(',').reverse unless key == 'Country'
                value = value
                key = key.split(/(?=[A-Z])/).join(' ')
                text_output += "#{key}: #{value}\n"
              end   
              bot.api.send_message(chat_id: message.chat.id, text: text_output) 
            end
          when Telegram::Bot::Types::CallbackQuery
            if message.data == 'location'
              kb = [
                Telegram::Bot::Types::KeyboardButton.new(text: 'Give Covid my Location', one_time_keyboard: true, request_location: true)
              ]
              markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb)
              bot.api.send_message(chat_id: message.from.id, text: 'Please provide me your location...', reply_markup: markup)
            
            elsif message.data == 'country'
              countries_array = covid_api.countries
              bot.api.send_message(chat_id: message.chat.id, text: 'Please type one of the following countries to get information:')
              bot.api.send_message(chat_id: message.chat.id, text: "#{countries_array.join(', ')}")
            end
            
            
        end
      end
    end
  end

  def reply(input)
    
  
  end
end




require 'telegram/bot'
require 'geocoder'
require_relative 'covid_api'

class Bot
  attr_reader :commands, :token

  def initialize(token) 
    @token = token
    start_telegram_api
  end

  private

  # Starts the bot input. 
  def start_telegram_api
    Telegram::Bot::Client.run(self.token) do |bot|
      listen(bot)
    end
  end

  #Listens for user input
  def listen(bot)
    bot.listen do |message|
      case message
      when Telegram::Bot::Types::Message
        
        case message.text
        when '/start'
          reply(bot, message.chat.id, "Hello, #{message.from.first_name}.")
          reply(bot, message.chat.id, "This is the latest update on Covid for #{Date.today.strftime('%a, %-d %b of %Y:')}")
          reply(bot, message.chat.id, search('/start'))
          reply(bot, message.chat.id, 'Please select one of the following options', main_menu)

        else
          reply(bot, message.chat.id, "I can't help you, please select from the following options:", main_menu)
        end

        # Provides stats according to the country if given a location. 
        location = Geocoder.search([message.location.latitude, message.location.longitude]) if message.location
        reply(bot, message.chat.id, search('location', location)) if message.location

      when Telegram::Bot::Types::CallbackQuery
        case message.data
        when 'location'
          reply(bot, message.from.id, 'Please provide me your location...', inline_menu)

        when 'country'
          reply(bot, message.from.id, 'Please type one of the following countries to get information:')
          reply(bot, message.from.id, search('country'))

        else
          reply(bot, message.from.id, "I don't know how to help you with this")
        end
      end
    end
  end

  # Replies messages to the user
  def reply(bot, chat_id, content, markup = nil )
    bot.api.send_message(chat_id: chat_id, text: content, reply_markup: markup)
  end

  # Connects with the Covid API Class
  def search(command, location = nil)
    covid_api = CovidApi.new

    case command
    when '/start'
      content_hash = covid_api.summary
      text_output = ''
      content_hash.each do |key, value|
        value = value.to_s.reverse.scan(/\d{1,3}/).join(',').reverse
        key = key.split(/(?=[A-Z])/).join(' ')
        text_output += "#{key}: #{value}\n"
      end

      return text_output

    when 'country'
      return covid_api.countries.join(', ')

    when 'location'
      if location
        country = covid_api.country(location.first.country)
        text_output = ''
        country.each do |key, value|
          value = value.to_s.reverse.scan(/\d{1,3}/).join(',').reverse unless key == 'Country'
          value = value
          key = key.split(/(?=[A-Z])/).join(' ')
          text_output += "#{key}: #{value}\n"
        end
      else
        text_output = "Unable to find location"
      end
      return text_output

    else
      'No answer'
    end

  end

  # Provides the user with the current options
  def main_menu
    kb = [
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Latest news on Covid', url: 'https://news.google.com/covid19/map?hl=en-US&gl=US&ceid=US:en'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'What is the situation in my country?', callback_data: 'location'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Select a specific country', callback_data: 'country')
    ]
    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
  end

  # Prompts the user to provide its location
  def inline_menu
    kb = [
      Telegram::Bot::Types::KeyboardButton.new(text: 'Provide Covid my Location', request_location: true, one_time_keyboard: true)
    ]
    Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb)
  end
end

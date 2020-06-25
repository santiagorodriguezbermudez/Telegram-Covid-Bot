require 'telegram/bot'

class Bot
  attr_reader :commands
  def initialize(token) 
    @token = token
    @commands = {}
    upload_commands
    start_telegram_api(token)
  end

  private
  def start_telegram_api(token)
    Telegram::Bot::Client.run(token) do |bot|
      bot.listen do |message|
        case message.text
        when '/start'
          bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
          
          bot.api.send_message(chat_id: message.chat.id, text: )
        when '/stop'
          bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
        end
      end
    end
  end

  def upload_commands
    return self.commands    
  end

end




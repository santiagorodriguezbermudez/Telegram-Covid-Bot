require_relative '../lib/bot.rb'

describe Bot do
  let(:bot) { Bot.new }

  describe '#initialize' do  
    it 'Starts the Bot without error' do
      expect(bot.class).to eql (Bot)
    end
  end

  describe '#reply' do    
    it 'Returns Hash for Telegram Server to read' do
      result = bot.text_reply
      expect(result.class).to eql (Hash)
    end
  end

end
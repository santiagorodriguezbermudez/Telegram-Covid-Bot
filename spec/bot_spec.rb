require_relative '../lib/bot.rb'

describe Bot do
  let(:bot) { Bot.new }

  describe '#initialize' do
    it 'Starts the Bot without error' do
      expect(bot.class).to eql Bot
    end
  end
end

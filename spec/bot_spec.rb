require_relative '../lib/bot'
require 'geocoder'
require 'dotenv'

Dotenv.load

describe Bot do
  let(:bot) {Bot.new(ENV['token'])}


  describe '#search' do 

    it 'Returns a succesful search given a location' do
      location = Geocoder.search('Saudi Arabia')
      expect(bot.search('location', location).class).to eql(String)
    end
  end
end
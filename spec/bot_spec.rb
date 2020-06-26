# require_relative '../lib/bot'
# require_relative '../lib/covid_api'
# require 'geocoder'
# require 'dotenv'

# Dotenv.load

# describe Bot do
#   p 'starts?'
#   let(:bot) {Bot.new(ENV['token'])}
#   p 'continues?'
#   let (:array_slug) { [] }

#   describe '#search' do 

#     it 'Returns a succesful search given a location for a country with a compound name' do
#       p bot
#       array_slug = bot.search('countries').split(', ')
#       p array_slug
#       array_slug.each do |slug|
#         slug = slug.split('-').map{|w| w.capitalize}.join(' ')
#         p slug
#         location = Geocoder.search(slug)
#         p location.first.country  
#         expect(bot.search('location', location).class).to eql(String)
#       end
#     end
#   end
# end
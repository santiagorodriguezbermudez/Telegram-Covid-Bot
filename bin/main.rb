require 'telegram/bot'
require 'dotenv'
require_relative '../lib/bot.rb'

Dotenv.load
Bot.new(ENV['token'])


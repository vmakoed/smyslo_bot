# frozen_string_literal: true

require 'rubygems'
require 'telegram_bot'
require 'weighted_randomizer'

TOKEN = ENV['SMYSLOBOT_TOKEN']
SYMBOLS_THRESHOLD = ENV['SMYSLOBOT_THRESHOLD'].to_i
REPLY = 'Ух, сука, со смыслом'
FIBONACCI = [
  3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 610, 987, 1597, 584, 4181, 6765
].freeze

@big_messages_total = 0
@fibonacci_counter = 0

find_smysl = lambda do
  smysl = (@big_messages_total % FIBONACCI[@fibonacci_counter]).zero?
  smysl.tap { |any_smysl| @big_messages_total = 0 if any_smysl }
end

has_smysl = lambda do |text|
  return false if text.size < SYMBOLS_THRESHOLD

  @big_messages_total += 1
  find_smysl.call
end

so_smyslom = lambda do |reply, bot|
  reply.tap { |reply_object| reply_object.text = REPLY }.send_with(bot)
  @fibonacci_counter += 1
end

bot = TelegramBot.new(token: TOKEN)
bot.get_updates(fail_silently: true) do |message|
  next unless has_smysl.call(message.text)

  message.reply { |reply| so_smyslom.call(reply, bot) }
end

require 'rubygems'
require 'telegram_bot'
require 'weighted_randomizer'

TOKEN = '626334553:AAG_TKzC6iwbgihU2hgQZlZT9VSG0hqxs8M'
REPLY = 'Ух, сука, со смыслом'
DECISIONS = { true => 1, false => 20 }

bot = TelegramBot.new(token: TOKEN)
randomizer = WeightedRandomizer.new(DECISIONS)

bot.get_updates(fail_silently: true) do |message|
  puts "@#{message.from.username}: #{message.text}"
  message.reply do |reply|
    randomizer.sample && reply.tap { |reply_object| reply_object.text = REPLY }.send_with(bot)
  end
end

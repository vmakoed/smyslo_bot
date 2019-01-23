# frozen_string_literal: true

require 'rubygems'
require 'telegram_bot'
require 'date'
require 'pry'

class SmyslFinder
  attr_accessor :big_messages_total, :last_message_date

  SYMBOLS_THRESHOLD = ENV['SMYSLOBOT_THRESHOLD'].to_i
  FIBONACCI = [3, 5, 8, 13].freeze
  TOKEN = ENV['SMYSLOBOT_TOKEN']
  REPLY = 'Ух, сука, со смыслом'

  def initialize
    @bot = TelegramBot.new(token: TOKEN)
    @big_messages_total = 0
    @last_message_date = nil
  end

  def run
    @bot.get_updates(fail_silently: true) do |message|
      reply(message)
    end
  end

  def reply(message)
    reset_counter if @last_message_date&.<(DateTime.now.new_offset.to_date)
    @last_message_date = message.date.to_date

    return unless smysl?(message.text)

    message.reply { |reply| so_smyslom(reply) }
  end

  private

  def find_smysl
    (@big_messages_total % FIBONACCI.sample).zero?
  end

  def smysl?(text)
    return false if text.size < SYMBOLS_THRESHOLD

    @big_messages_total += 1
    find_smysl
  end

  def so_smyslom(reply)
    reply.tap { |reply_object| reply_object.text = REPLY }.send_with(@bot)
  end

  def reset_counter
    @big_messages_total = 0
  end
end
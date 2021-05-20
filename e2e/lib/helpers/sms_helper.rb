require 'twilio-ruby'
require 'singleton'

# Helper class for SMS messaging via Twillio.
#
# This helper is useful if you need to test something that should generate
# a text message.  It exposes methods for checking for received text messages.
#
# Relies on the TWILLIO_SID and TWILLIO_TOKEN env vars.
#
class SMSHelper
  include Singleton

  # @!visibility private
  TWILLIO_SID ||= Nenv.twillio_sid
  # @!visibility private
  TWILLIO_TOKEN ||= Nenv.twillio_token

  DEFAULT_SMS_TIMEOUT ||= 600

  attr_reader :client

  def initialize
    @client = Twilio::REST::Client.new TWILLIO_SID, TWILLIO_TOKEN
  end

  # @return [Twilio::REST::Client] The client used for Twillio
  def self.twillio
    SMSHelper.instance.client
  end

  # Get all of the received SMS messages for a given day, by default today.
  #
  # @param date [Date] The day for which to check messages
  # @return An array of hashes with :from and :body keys
  def self.received_messages(date=Date.today)
    twillio.messages.list(date_sent: date).map { |m| { from: m.from, body: m.body } }
  end

  # Get all of the received SMS messages for a given day from a particular sender, by default today.
  #
  # @param sender [String] A phone number from which the message should be from in the form of '+16142703029'
  # @param date [Date] The day for which to check messages
  # @return An array of strings representing the body of the messages
  def self.received_messages_from(sender, date=Date.today)
    twillio.messages.list(date_sent: date, from: sender).map(&:body)
  end

  # Check to see if we have any messages with a specific body
  #
  # @param body [String] The body text to look for
  # @param date [Date] The day for which to check messages
  # @return [Boolean]
  def self.have_message_with_body?(body, date=Date.today)
    received_messages(date).any? { |m| m[:body] == body}
  end

  # Check to see if we have any messages with a specific body, from a specific sender
  #
  # @param sender [String] A phone number from which the message should be from in the form of '+16142703029'
  # @param body [String] The body text to look for
  # @param date [Date] The day for which to check messages
  # @return [Boolean]
  def self.have_message_from_with_body?(sender, body, date=Date.today)
    received_messages_from(sender, date).any? { |m| m == body}
  end

  # Wait until a message can be found that matches a particular body
  #
  # @param body [String] The body text to look for
  # @param timeout [Integer] How long to wait
  # @param date [Date] The day for which to check messages
  # @return An array of hashes with :body keys
  def self.wait_for_message(body, timeout=DEFAULT_SMS_TIMEOUT, date=Date.today)
    Watir::Wait.until(timeout: timeout) { have_message_with_body?(body, date) }
    received_messages(date).select { |m| m[:body] == body}
  end

  # Wait until a message can be found that matches a particular body, from a specific sender
  #
  # @param sender [String] A phone number from which the message should be from in the form of '+16142703029'
  # @param body [String] The body text to look for
  # @param timeout [Integer] How long to wait
  # @param date [Date] The day for which to check messages
  # @return An array of hashes with :body keys
  def self.wait_for_message_from_with_body(sender, body, timeout=DEFAULT_SMS_TIMEOUT, date=Date.today)
    Watir::Wait.until(timeout: timeout) { have_message_from_with_body?(sender, body, date) }
    received_messages_from(sender, date).select { |m| m == body}
  end
end

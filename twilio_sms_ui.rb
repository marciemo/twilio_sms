require 'faraday'
require 'json'
require 'base64'
require 'active_model'

require './lib/message'

ACCOUNT_SID = 'AC143a708153cfd54cf36a849df2eea04e'
AUTH_TOKEN = 'eeb0407ce992ccf115d6cca106af9116'
$user_number = '+14087035672'

def welcome
  puts "Welcome to the Twilio SMS command-line client."
  send_message
end

def send_message
  phone_numbers = []
  puts "Type a phone number to send a text."
  phone_numbers << gets.chomp
  choice = nil
  until choice == 'n'
  puts "Would you like to add another number? (y/n)"
  choice = gets.chomp
    if choice == 'y'
      puts "Enter the number to add:"
      phone_numbers << gets.chomp
    end
  end
  puts "Type your message."
  message_body = gets.chomp
  phone_numbers.map do |number|
    message = Message.create(:from => $user_number, :to => number, :body => message_body)
    if message.successful?
      puts "Your message was sent to #{message.to}"
    else
      puts "There was an error sending your message to #{message.to}"
    end
  end
end

welcome

# +14153024672
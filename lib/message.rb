require 'active_model'

class Message
  include ActiveModel::Validations

  attr_accessor :from, :to, :body

  validates :from, :to, :presence => true, :length => { :minimum => 12, :maximum => 12 }, :format => { :with => /\+1[2-9]\d*/}
  validates :body, :presence => true, :length => { :minimum => 1, :maximum => 160 }

  def initialize(response_attributes)
    @from = response_attributes[:from]
    @to = response_attributes[:to]
    @body = response_attributes[:body]
    @status = response_attributes[:status]
  end

  def self.create(attributes)
    faraday_response = Faraday.post do |request|
      request.url "https://api.twilio.com/2010-04-01/Accounts/#{ACCOUNT_SID}/SMS/Messages.json"
      request.headers['Authorization'] = "Basic " + Base64.strict_encode64("#{ACCOUNT_SID}:#{AUTH_TOKEN}")
      request.body = URI.encode_www_form({'From' => attributes[:from], 'To' => attributes[:to], 'Body' => attributes[:body]})
    end
    status = faraday_response.status
    self.new(:from => attributes[:from], :to => attributes[:to], :body => attributes[:body], :status => status)
  end

  def successful?
    @status == 201 || @status == 200
  end
end
require 'spec_helper'

describe Message do

  let(:from) {'+15005550006'}
  let(:to) {'+14157285791'}
  let(:body) {'rolling now!'}
  # let(:stub) {stub_request(:post, "https://#{ACCOUNT_SID}:#{AUTH_TOKEN}@api.twilio.com/2010-04-01/Accounts/#{ACCOUNT_SID}/SMS/Messages.json").with(:body => URI.encode_www_form('From' => from, 'To' => to, 'Body' => body))}

  context '#initialize' do
    it 'creates an instance of message with an argument' do
      message = Message.new(:from => '+12345678912', :to => '+12345678912', :body => 'test')
      message.should be_an_instance_of Message
    end
  end

  context 'accessors' do
    it 'returns the number for from' do
      message = Message.new(:from => '+12345678912', :to => '+12345678912', :body => 'test')
      message.from.should eq '+12345678912'
    end

    it 'returns the number for to' do
      message = Message.new(:from => '+12345678912', :to => '+13456789123', :body => 'test')
      message.to.should eq '+13456789123'
    end

    it 'returns the text for body' do
      message = Message.new(:from => '+12345678912', :to => '+12345678912', :body => 'test')
      message.body.should eq 'test'
    end

    it 'returns the code for status' do
      message = Message.new(:from => '+12345678912', :to => '+12345678912', :body => 'test', :status => 200)
      message.status.should eq 200
    end
  end

  context '#valid?' do
    it 'is valid with a from phone number' do
      message = Message.new(:from => '+12345678912', :to => '+12345678912', :body => 'test')
      message.valid?.should be_true
    end

    it 'is not valid without a from phone number' do
      message = Message.new(:to => '+12345678912', :body => 'test')
      message.valid?.should be_false
    end

    it 'is valid with a to phone number' do
      message = Message.new(:from => '+12345678912', :to => '+12345678912', :body => 'test')
      message.valid?.should be_true
    end

    it 'is not valid without a to phone number' do
      message = Message.new(:from => '+12345678912', :body => 'test')
      message.valid?.should be_false
    end

    it 'is valid when body is present' do
      message = Message.new(:from => '+12345678912', :to => '+12345678912', :body => 'test')
      message.valid?.should be_true
    end

    it 'is not valid when body is missing' do
      message = Message.new(:to => '+12345678912', :from => '+12345678912')
      message.valid?.should be_false
    end

    it 'is valid when body is at least 1 character in length' do
      message = Message.new(:from => '+12345678912', :to => '+12345678912', :body => 'test')
      message.valid?.should be_true
    end

    it 'is not valid when body is empty' do
      message = Message.new(:from => '+12345678912', :to => '+12345678912', :body => '')
      message.valid?.should be_false
    end

    it 'is not valid when body is more than 160 characters in length' do
      message = Message.new(:from => '+12345678912', :to => '+12345678912', :body => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vitae leo metus, eget pharetra nibh. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices nullam')
      message.valid?.should be_false
    end

    it 'is valid when to and from follow the format: +1 followed by a 10 digit string' do
      message = Message.new(:from => "+15005550006", :to => "+14157285791", :body => 'rolling now!')
      message.valid?.should be_true
    end

    it 'is not valid when from or to do not have the number 1 as first digit' do
      message = Message.new(:from => "+25005550006", :to => "+24157285791", :body => 'rolling now!')
      message.valid?.should be_false
    end

    it 'is not valid when to or from do not start with a +' do
      message = Message.new(:from => "-15005550006", :to => "-14157285791", :body => 'rolling now!')
      message.valid?.should be_false
    end

    it 'is not valid when to or from are not exactly 12 characters in length' do
      message = Message.new(:from => "+150055500", :to => "+1415728579", :body => 'rolling now!')
      message.valid?.should be_false
    end
  end

  context '.send_message' do
    it 'POSTs a new text to the Twilio API' do
      stub = stub_request(:post, "https://#{ACCOUNT_SID}:#{AUTH_TOKEN}@api.twilio.com/2010-04-01/Accounts/#{ACCOUNT_SID}/SMS/Messages.json").with(:body => URI.encode_www_form('From' => from, 'To' => to, 'Body' => body))
      Message.create(:from => from, :to => to, :body => body)
      stub.should have_been_requested
    end

    it 'returns an instance of Message' do
      stub = stub_request(:post, "https://#{ACCOUNT_SID}:#{AUTH_TOKEN}@api.twilio.com/2010-04-01/Accounts/#{ACCOUNT_SID}/SMS/Messages.json").with(:body => URI.encode_www_form('From' => from, 'To' => to, 'Body' => body))
      sent_message = Message.create(:from => from, :to => to, :body => body)
      sent_message.should be_an_instance_of Message
    end
  end

  context '#successful?' do
    it 'returns true when the message send has been successful' do
      stub = stub_request(:post, "https://#{ACCOUNT_SID}:#{AUTH_TOKEN}@api.twilio.com/2010-04-01/Accounts/#{ACCOUNT_SID}/SMS/Messages.json").with(:body => URI.encode_www_form('From' => from, 'To' => to, 'Body' => body))
      message = Message.create(:from => from, :to => to, :body => body)
      message.successful?.should be_true
    end

    it 'returns false if it is not successful' do
      stub = stub_request(:post, "https://#{ACCOUNT_SID}:#{AUTH_TOKEN}@api.twilio.com/2010-04-01/Accounts/#{ACCOUNT_SID}/SMS/Messages.json").with(:body => URI.encode_www_form('From' => from, 'To' => "+14158297583", 'Body' => body))
      message = Message.create(:from => from, :to => "+14158297583", :body => body)
      message.successful?.should be_false
    end
  end
end
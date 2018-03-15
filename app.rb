# coding: utf-8
require "sinatra"
require "json"
require "slack-ruby-client"

require_relative "chousei.rb"

VERIFICATION_TOKEN = ENV['SLACK_VERIFICATION_TOKEN']

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
  raise 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
end
client = Slack::Web::Client.new

get '/' do
  "Hello heroku."
end

post '/command/chousei' do
  if params["token"] != VERIFICATION_TOKEN
    $stderr.puts "invalid token: #{params["token"]}"
  else
    date_from, date_to = params["text"].split.map{|s| Time.parse(s)}
    date_from = Time.now if date_from.nil?
    date_to = date_from + 60*60*24*31 if date_to.nil?
    client.chat_postMessage(channel: params["channel_id"], text: '調整さん in Slack', attachments: Chousei.attachments(Chousei.holidays(date_from, date_to)))
  end
  body "調整 done"
end

post '/interactive' do
  req = JSON.parse params["payload"]
  if req["token"] != VERIFICATION_TOKEN
    $stderr.puts "invalid token: #{req["token"]}"
  else
    user_action = req["actions"][0]
    channel = req["channel"]
    username = req["user"]["name"]
    if user_action["type"] == "select"
      if user_action["name"] =~ /^chousei_type_list/
        orig = req["original_message"]
        updated = Chousei::Interactive.update_attachments orig["attachments"], username, user_action
        client.chat_update(channel: channel["id"], text: orig["text"], attachments: updated, ts: orig["ts"])
      end
    end
  end
  body ""
end

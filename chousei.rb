# coding: utf-8

require "json"
require "time"

module Chousei
  def self.attachments dates
    counter = -1
    dates.map do |date|
      {
        text: "#{date}
:smiley: : 
:thinking_face: : 
:confounded: : ",
        fallback: "You are unable to choose",
        callback_id: "chousei_selection",
        color: "#3AA3E3",
        attachment_type: "default",
        short: true,
        actions: [
          {
            name: "chousei_type_list_#{counter+=1}",
            text: "選択",
            type: "select",
            options: [
              {
                text: "○",
                value: "ok"
              },{
                text: "△",
                value: "maybe"
              },{
                text: "×",
                value: "ng"
              }
            ]
          }
        ]
      }
    end
  end
  
  def self.holidays(date_from=Time.now, date_to=nil)
    date_to = date_from + 60*60*24*31 if date_to.nil?
    days = ((date_to - date_from)/60/60/24).to_i  #60*60*24 surusikanainoka
    dates = (0...days).map do |i|
      date_from + i*60*60*24
    end
    weekends = dates.select do |date|
      date.wday == 0 or date.wday == 6
    end
    holidays_url = "https://holidays-jp.github.io/api/v1/#{date_from.year}/date.json"
    res = `curl #{holidays_url}`
    raise "Not connectable for #{holidays_url}" if res.nil?
    holidays_json = JSON.parse res
    holidays_time = holidays_json.keys.map{|e| Time.parse e}
    holidays_duration = holidays_time.select{|t| date_from <= t and t <= date_to}
    week_jp = ["日", "祝", "祝", "祝", "祝", "祝", "土"]
    return (weekends + holidays_duration).sort.uniq.map{|d| "#{d.month}/#{d.day} (#{week_jp[d.wday]})"}
  end
  
  module Interactive
    def self.parse_field_text text
      lines = text.split("\n")
      header = lines.shift
      users = lines.map do |line|
        splited = line.split(" : ")
        if splited[1].nil?
          [splited[0], []]
        else
          [splited[0], splited[1].split(", ")]
        end
      end
      return header, users
    end
    
    def self.compose_field_text header, users
      text = users.map do |line|
        [line[0], line[1].join(", ")].join(" : ")
      end.join "\n"
      return [header, text].join "\n"
    end
    
    def self.update_attachments attachments, username, user_action
      attach_index = attachments.index{|a| a["actions"][0]["name"] == user_action["name"]}
      attach_field = attachments[attach_index]
      header, users = parse_field_text attach_field["text"]
      users.map{|e| e[1].delete(username)}
      case user_action["selected_options"][0]["value"]
      when "ok"
        users[0][1] << username
      when "maybe"
        users[1][1] << username
      when "ng"
        users[2][1] << username
      end
      attach_field["text"] = compose_field_text header, users
      attach_field["color"] = update_color users
      attachments[attach_index] = attach_field
      selected_option = attach_field["actions"][0]["options"].find do |o|
        o["value"] == user_action["selected_options"][0]["value"]
      end
      attachments[attach_index]["actions"][0]["selected_options"] = [selected_option]
      return attachments
    end
    
    def self.update_color users
      users_count = users.inject(0){|sum,u| sum + u[1].size}
      if users[0][1].size == users_count
        "good"
      elsif users[2][1].size == 0
        "warning"
      else
        "danger"
      end
    end
  end
end


=begin
attachments = [
  {
    text: "調整さん in Slack",
    fallback: "You are unable to choose",
    callback_id: "chousei",
    color: "#3AA3E3",
    attachment_type: "default",
    actions: [
      {
        name: "game",
        text: "3/3",
        type: "button",
        style: "default",
        value: "chess"
      }, {
        name: "game",
        text: "3/4",
        type: "button",
        style: "primary",
        value: "maze"
      }, {
        name: "game",
        text: "Thermonuclear War",
        style: "danger",
        type: "button",
        value: "war",
        confirm:
          {
            title: "Are you sure?",
            text: "Wouldn't you prefer a good game of chess?",
            ok_text: "Yes",
            dismiss_text: "No"
          }
      }
    ]
  }
]
=end

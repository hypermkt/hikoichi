# -*- coding: utf-8 -*-
require 'simple-rss'
require 'open-uri'
require 'yaml'
require 'digest/md5'
require 'nokogiri'
require 'cinch'

require_relative './wordpress.rb'
require_relative './movabletype.rb'
require_relative './soycms.rb'
require_relative './xoops.rb'

CHECK_FILE = 'checked_list.txt'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = ""
    c.password = ""
    c.channels = ["#"]
    c.port =
    c.nick = "hikoichi"
    c.ssl.use = true
  end

  on :message, "check cms" do |m|

    m.reply "要チェックや〜！"
    yaml = YAML.load_file "packages.yaml"
    yaml['packages'].each do |package|
      mod = Module.new
      cms = mod.const_get(package['class']).new(package)
      list = cms.check

      list.each do|message|
        m.reply message
      end
    end
    m.reply "終わり！"
  end
end

bot.start

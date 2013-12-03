# -*- coding: utf-8 -*-

require 'simple-rss'
require 'open-uri'
require 'yaml'
require 'nokogiri'
require 'yaml'
require 'net/http'

require_relative './wordpress.rb'
require_relative './movabletype.rb'
require_relative './soycms.rb'
require_relative './xoops.rb'
require_relative './mediawiki.rb'

CHECK_FILE = 'checked_list.txt'

class Hikoichi
  def initialize
    @packages = YAML.load_file "packages.yaml"
    @config = YAML.load_file "config.yaml"
  end

  def ikachan_post(message)
    Net::HTTP.post_form(URI.parse(@config['irc']['host']), {
      'channel' => @config['irc']['channel'],
      'message' => message,
    })
  end

  def check
    ikachan_post('要チェック〜！')
    @packages['packages'].each do |package|
      mod = Module.new
      cms = mod.const_get(package['class']).new(package)
      list = cms.check
      list.each do|message|
        ikachan_post(message)
      end
    end
    ikachan_post('終わり！')
  end
end

hikoichi = Hikoichi.new
hikoichi.check

# -*- coding: utf-8 -*-

require 'simple-rss'
require 'open-uri'
require 'yaml'
require 'nokogiri'
require 'yaml'

require_relative './wordpress.rb'
require_relative './movabletype.rb'
require_relative './soycms.rb'
require_relative './xoops.rb'
require_relative './mediawiki.rb'

CHECK_FILE = 'checked_list.txt'

yaml = YAML.load_file "packages.yaml"
yaml['packages'].each do |package|
  mod = Module.new
  cms = mod.const_get(package['class']).new(package)
  list = cms.check
  list.each do|message|
    # TODO: call ikachan
  end
end

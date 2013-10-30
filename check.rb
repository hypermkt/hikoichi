# -*- coding: utf-8 -*-
require 'simple-rss'
require 'open-uri'
require 'yaml'
require 'digest/md5'
require 'nokogiri'
require 'cinch'

CHECK_FILE = 'checked_list.txt'

class WordPress
    def initialize(package)
        @package = package
    end

    def check
        page = open(@package['feed_url'])
        rss = SimpleRSS.parse(page)
        file = File.read(CHECK_FILE)
        list = Array.new
        rss.items.each do|item|
            url = item.link
            if !file.include?(url) &&
                item.title.force_encoding("UTF-8").include?('リリース')
                File.open(CHECK_FILE,"a"){|f|
                    f.puts url
                }
                message = sprintf("[%s] %s %s %s",
                                  @package['name'],
                                  item.pubDate.strftime("%Y/%m/%d"),
                                  item.title,
                                  item.link)
                list.push(message)
            end
        end
        return list
    end
end

class MovableType
    def initialize(package)
        @package = package
    end

    def check
        page = open(@package['feed_url'])
        rss = SimpleRSS.parse(page)
        file = File.read(CHECK_FILE)
        list = Array.new
        rss.entries.each do|item|
            url = item.link
            if !file.include?(url) &&
                item.title.force_encoding("UTF-8").include?('リリース')
                File.open(CHECK_FILE,"a"){|f|
                    f.puts url
                }
                message = sprintf("[%s] %s %s %s",
                                  @package['name'],
                                  item.published.strftime("%Y/%m/%d"),
                                  item.title,
                                  item.link)
                list.push(message)
            end
        end
        return list
    end
end

class Xoops
    def initialize(package)
        @package = package
    end

    def check
        page = open(@package['feed_url'])
        rss = SimpleRSS.parse(page)
        file = File.read(CHECK_FILE)
        list = Array.new
        rss.items.each do|item|
            url = item.link
            if !file.include?(url) &&
                item.title.force_encoding("UTF-8").include?('リリース')
                File.open(CHECK_FILE,"a"){|f|
                    f.puts url
                }
                message = sprintf("[%s] %s %s %s",
                                  @package['name'],
                                  item.dc_date.strftime("%Y/%m/%d"),
                                  item.title,
                                  item.link)
                list.push(message)
            end
        end
        return list
    end
end

class SoyCMS
    def initialize(package)
        @package = package
    end

    def check
        list = Array.new
        file = File.read(CHECK_FILE)
        list = Array.new
        doc = Nokogiri::HTML::parse(open(@package['feed_url']), nil, 'utf-8')
        doc.css('.main-content//ul//li').each do|elm|
            url = 'http://www.soycms.net/topics' + elm.css('a').attribute('href')
            title = elm.css('a').text
            if !file.include?(url) &&
               title.include?('SOY CMS') &&
               title.force_encoding('UTF-8').include?('リリース')
                File.open(CHECK_FILE,"a"){|f|
                    f.puts url
                }
                elm.css('a').remove
                date = elm.text
                message = sprintf("[%s] %s %s %s",
                                  @package['name'],
                                  date,
                                  title,
                                  url)
                list.push(message)
            end
        end
        return list
    end
end

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

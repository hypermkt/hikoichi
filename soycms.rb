# -*- coding: utf-8 -*-
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

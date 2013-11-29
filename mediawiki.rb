# -*- coding: utf-8 -*-
class MediaWiki
  def initialize(package)
    @package = package
  end

  def check
    list = Array.new
    file = File.read(CHECK_FILE)
    doc = Nokogiri::HTML::parse(open(@package['feed_url']), nil, 'utf-8')
    doc.css('#mw-content-text//dl').each do|elm|
      date = elm.css('dt').text
      if elm.next_element.nil? ||
        elm.next_element.xpath('li//a').empty?
        next
      end
      title = elm.next_element.css('li').text
      puts elm.next_element
      url = elm.next_element.xpath('li//a').attribute("href").value
      if !file.include?(url) &&
        title.include?('MediaWiki') &&
        title.force_encoding('UTF-8').include?('リリース')
        File.open(CHECK_FILE,"a"){|f|
          f.puts url
        }
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

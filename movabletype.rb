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

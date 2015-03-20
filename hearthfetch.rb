require 'sinatra'
require 'uri'
require 'json'
SLACK_TOKEN = ENV['SLACK_TOKEN']
helpers do 
    def get_card(name)
        begin
            require 'nokogiri'
            require 'open-uri'
            doc = Nokogiri::HTML(open(URI.encode("http://hearthstone.wikia.com/wiki/Special:Search?search=#{name}&fulltext=Search&ns0=1&ns14=1#")))
            stuff = doc.xpath("//a[@class='result-link']").map{|x| x.content}
            res = Nokogiri::HTML(open(stuff[1])).xpath("//img").xpath("//div[@class='tooltip-content']")[0].children[0]["href"]
        rescue
            res = "Not found. You messed something up, didn't you? You did. You messed something up."
        end
        return res
    end
end

post '/' do
    halt 401 unless params['token'] = SLACK_TOKEN
    trigger=params['trigger_word']
    card = params['text'].scan(/#{trigger}(.*)/).flatten[0].strip
    return JSON.generate({
        username: "pix",
        text: get_card(card),
        icon_emoji: ":shipit:"
    })
end

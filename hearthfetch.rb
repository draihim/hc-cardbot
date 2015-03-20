require 'sinatra'
require 'uri'
require 'json'
require 'nokogiri'
require 'open-uri'

helpers do 
    def get_card(name)
        begin
            doc = Nokogiri::HTML(open(URI.encode("http://hearthstone.wikia.com/wiki/Special:Search?search=#{name}&fulltext=Search&ns0=1&ns14=1#")))
            stuff = doc.xpath("//a[@class='result-link']").map{|x| x.content}
            card_url = Nokogiri::HTML(open(stuff[1])).xpath("//img").xpath("//div[@class='tooltip-content']")[0].children[0]["href"]
        end

    end
end

    post '/' do
        begin
            trigger=params['trigger_word']
            card = params['text'].scan(/#{trigger}(.*)/).flatten[0].strip
            url = get_card(card)
        rescue
            url = "Not found. Did you mess something up? You did. You messed something up."
            return JSON.generate({
                username: "pix",
                icon_emoji: ":shipit:",
                text: url
            }) 
    end

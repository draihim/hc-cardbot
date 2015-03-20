require 'sinatra'
require 'uri'
require 'json'
helpers do 
    def get_card(name)
        require 'nokogiri'
        require 'open-uri'
        doc = Nokogiri::HTML(open(URI.encode("http://hearthstone.wikia.com/wiki/Special:Search?search=#{name}&fulltext=Search&ns0=1&ns14=1#")))
        stuff = doc.xpath("//a[@class='result-link']").map{|x| x.content}
        card_url = Nokogiri::HTML(open(stuff[1])).xpath("//img").xpath("//div[@class='tooltip-content']")[0].children[0]["href"]
        return JSON.generate({"text" => card_url})
    end

end

post '/' do
    puts params
    get_card(params['card'])
end

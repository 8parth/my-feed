class HomeController < ApplicationController
  def index
    url = "http://showrss.info/feeds/505.rss"
    #url2 = "http://showrss.info/feeds/928.rss"
    feed =  Feedjira::Feed.fetch_and_parse(url)
    @new_feed = Feed.create(title: feed.title, url: feed.url)
    puts @new_feed.inspect  


    @entries = feed.entries

    puts @entries.inspect
  end

  def gotham
    url = "http://showrss.info/feeds/928.rss"
    feed =  Feedjira::Feed.fetch_and_parse(url)
    @new_feed = Feed.create(title: feed.title, url: feed.url)
    puts @new_feed.inspect  


    @entries = feed.entries

    puts @entries.inspect

  end
end

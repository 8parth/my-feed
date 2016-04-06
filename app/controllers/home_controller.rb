class HomeController < ApplicationController
  require 'pismo'
  require 'mechanize'

  def index
    url = "http://showrss.info/feeds/505.rss"
    #url2 = "http://showrss.info/feeds/928.rss"
    feed =  Feedjira::Feed.fetch_and_parse(url)
    @new_feed = Feed.create(title: feed.title, url: feed.url)
    puts @new_feed.inspect  


    @entries = feed.entries

    puts @entries.inspect
  end

  def get_feed(name)
    
    agent  = Mechanize.new
    #feed_link = Mechanize::Page::Link.new
    page = agent.get("http://showrss.info/?cs=feeds")
    form = page.forms[0]
    form.fields[1].options.each do |option|
      if option.text == name
        form.fields[1].value = option.value
      end
    end

    returned_page = form.submit
    links = returned_page.links

    links.each do |link|
      temp_link = link
      
      if temp_link.to_s.include?(".rss")
         
        return link.uri
      end
    end
    #form.fields[1].options.fourth.text 
    
  end

  #get 'home/user_feed'
  def user_feed
    url = nil
    if params[:feed_name].present?
      url = get_feed(params[:feed_name])
    else
      url = "http://showrss.info/feeds/505.rss"
    end
    
      feed =  Feedjira::Feed.fetch_and_parse(url)
      @new_feed = Feed.create(title: feed.title, url: feed.url)
        


      @entries = feed.entries

    
    
  end

  def gotham
    url = "http://showrss.info/feeds/928.rss"
    feed =  Feedjira::Feed.fetch_and_parse(url)
    @new_feed = Feed.create(title: feed.title, url: feed.url)
    puts @new_feed.inspect  


    @entries = feed.entries

    puts @entries.inspect

  end

  def got
    url = 'http://showrss.info/feeds/350.rss'

    feed =  Feedjira::Feed.fetch_and_parse(url)
    @new_feed = Feed.create(title: feed.title, url: feed.url)
    puts @new_feed.inspect  


    @entries = feed.entries

    puts @entries.inspect
  end
end

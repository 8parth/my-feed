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
    
    page = agent.get("http://showrss.info/?cs=feeds")
    form = page.forms[0]
    form.fields[1].options.each do |option|
      if option.text == name
        form.fields[1].value = option.value
    end

    returned_page = form.submit
    links = returned_page.links
    links.each do |link|
      link.contains
    end
    #form.fields[1].options.fourth.text
    link = page.link_with(:text => name)
    if !link.nil?      
      return link + ".rss"
    else
      return nil
    end
  end

  #get 'home/user_feed'
  def user_feed

    url = get_feed(params[:feed_name])
    if !url.nil?

      feed =  Feedjira::Feed.fetch_and_parse(url)
      @new_feed = Feed.create(title: feed.title, url: feed.url)
      puts @new_feed.inspect  


      @entries = feed.entries

      puts @entries.inspect
    else
      exit
    end
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

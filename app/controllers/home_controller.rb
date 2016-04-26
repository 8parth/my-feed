class HomeController < ApplicationController
  require 'pismo'
  require 'mechanize'

  before_action :authenticate_user!

  def index
    begin
      url = "http://showrss.info/feeds/505.rss"
    #url2 = "http://showrss.info/feeds/928.rss"
    feed =  Feedjira::Feed.fetch_and_parse(url)
    @new_feed = Feed.create(title: feed.title, url: feed.url)
      


    @entries = feed.entries  
    @shows = Show.all
    rescue Exception => e
      puts e
    end
    
    
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
        
    show_feed = params[:shows] if params[:shows].present?
    
    
    if params[:feed_name].present?
      url = get_feed(params[:feed_name])
    elsif !show_feed.nil?
      url = "http://showrss.info/feeds/#{show_feed}.rss"
      @feed =  Feedjira::Feed.fetch_and_parse(url)
      @new_feed = Feed.create(title: @feed.title, url: @feed.url)
      @entries = @feed.entries
    else
      #url = "http://showrss.info/feeds/505.rss"
      feed = nil
      @new_feed = nil
      @entries = nil
    end
    
      

      respond_to do |format|
        format.html 
        format.json { head :no_content }
        format.js   { render :layout => false }
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

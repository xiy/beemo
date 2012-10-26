![Beemo!](http://fc07.deviantart.net/fs70/f/2011/179/c/8/beemo_vector_by_adrienneorpheus-d3k9wnf.png "Beemo Vector by ~adrienneorpheus @ deviantart.com")

# Beemo

Beemo is a web scraper I wrote for a job interview that went AWOL. It ended up being one of my first forays into real Ruby development and is named after my favourite character from the Adventure Time cartoon series, Beemo - a robot, games console, and noir detective.

[Beemo Vector Art](http://adrienneorpheus.deviantart.com/art/Beemo-Vector-215453067) by ~adrienneorpheus

## How to use Beemo

I've tried to make Beemo as quick and easy to use as possible, in the spirit of Ruby (and Beemo itself). I based the design loosely on *scrAPI* by @assaf, except I'm using Capybara to scrape the web like a human, and Nokogiri if you need to scrape the web like a robot.

If you just want to a scrape a single piece of information from a site:

    require 'beemo'
    Beemo.scrape(source: 'http://www.google.com', selector: '//*[@id="gbqfq"]')

If however you want to scrape a larger amount of information, or you want to create a specialised scraper for a specific resource, you can inherit from the base scraper:

    class DerpScraper < Beemo::Scraper
        source 'http://www.google.com'
        scrape :name => :search_term, :selector => '//*[@id="gbqfq"]'
        scrape :name => :search_frame, :selector => '//*[@id="gbqf"]'
    end
    
    DerpScraper.new.process

**This project is considered a work in progress!**

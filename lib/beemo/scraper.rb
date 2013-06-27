# A Capybara-WebKit/Nokogiri-based scraper loosely based on scrAPI
#
# Copyright (c) 2012 Mark Anthony Gibbins (@xiy)

require 'capybara'
require 'capybara/dsl'
require 'capybara/webkit'
require 'uri'

module Beemo
  class Scraper
    include Capybara::DSL

    attr_accessor :source, :result, :current_uri, :options

    def initialize(source, options = {})
      @options ||= options.with_defaults! :driver => :webkit, :selector => :xpath
      @source = source

      Capybara.configure do |c|
        c.run_server = false
        c.current_driver = options[:driver]
        c.default_selector = options[:selector]
      end
    end

    # Defines a new Scraper object.
    #
    # Example:
    #   Scraper.define do
    #     scrape("html/body/a[1]", :first_link, :link => :text, :location => :href)
    #     scrape_text("/html/body/a[1]", :first_link_text)
    #   end
    #
    # You can also pass the Scraper a block using this method with a list of sources
    # to scrape from. The scraper will then yield the results of each one by one automatically.
    #
    # NOTE: This method of using the scraper is non-atomic and will only do the actual
    # scraping once get_results is called or yielded.
    def self.define(source, options = {}, &block)
      klass = Beemo::Scraper.new(source, options)
      klass.instance_eval(&block)
      return klass
    end

    # Selects the element within the source to scrape from.
    #
    # Can be any element within the source. Uses XPath to locate it
    # (use Firebug or any WebKit browser)
    #
    # Pass :css as 'selector' parameter to temporarily use CSS selectors instead.
    #
    def scrape(element, selector = :xpath)
      raise ArgumentError, "Source was nil, cannot scrape." if @source.nil?

      # Set the Capybara selector to :css if it's been passed.
      Capybara.default_selector = selector if selector != :xpath

      # If the source is an HTML fragment in the form of a Capybara::Node::Simple
      # instance, use the exposed method within the instance, otherwise use
      # the global Capybara method.
      if @source.is_a? Capybara::Node::Simple
        scraped_element = @source.find(element)
      else
        scraped_element = find(:content, element)
      end


      case scraped_element.tag_name.to_sym
      when :body
        # scraping the body tag so just return all the inner html?
        puts page.document.inspect
      end

      # Reset the selector back to the default.
      Capybara.default_selector = :xpath if selector != :xpath
    end

    # Scrapes the text content of the selected element.
    #
    # e.g <a href="#">This is text content.</a>
    def scrape_text(element)
      scrape element if !element.nil?
      return @result.text
    end

    # Scrapes the value from a form field element.
    def scrape_value(element)
      raise ArgumentError, "scrape_value: element was nil!" if element.nil?
      scrape element
      return @result.value
    end

    # Scrapes the value of an elements attribute.
    def scrape_attribute_value(element, attribute)
      scrape element if !element.not_nil?
      return @result[attribute]
    end

    # Logs in using a login form on the current_uri. You can optionally supply
    # the name/id of the individual elements in the log in form.
    #
    # Parameters:
    #   username: The username used to log in.
    #   password: The password used to log in.
    #
    # Optional parameters:
    #   username_element: The name or id of the username/email field element.
    #   password_element: The name or id of the password field element.
    #   submit_form_element: The name or id of the submit button element.
    #
    def login(username, password, custom_element_names = {})
      custom_element_names.reverse_merge! :username => "username", :password => "password", :submit_button => "Log In"
      fill_in(element_names[:username], :with => username_element)
      fill_in(element_names[:password], :with => password)
      click_button(element_names[:submit_button])
    end

    # Assigns a source to the scraper for it to scrape from.
    #
    # Valid source types are:
    #   String
    #   URI
    #   Capybara::Node::Simple (from a String fragment)
    #
    def source=(source)
      raise ArgumentError, "You need to give me a source." if source.nil?

      case source
      when ::String
        if source.start_with? "http://" or source.start_with? "www."
          @source = Capybara.app_host = source
        else
          @source = Capybara.string(source)
        end
      when ::URI::HTTP, ::Capybara::Node::Simple
        @source = source
      else
        raise ArgumentError
      end
    end

  end
end

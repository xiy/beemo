require 'spec_helper'
require 'beemo'

describe Beemo::Scraper do
  let(:invalid_source_type) { [] }
  let(:url_string_source) { "http://www.yelp.co.uk" }
  let(:uri_source) { URI(url_string_source) }

  let(:string_source) { <<-HTML
    <html lang="en">
    <head>
    <title>Scraping Test</title>
    </head>
    <body>
      <img src="image.png" alt="test_image">
      <input type="text" value="London" name="find_desc">
      <a href="/location/london">London</a>
    </body>
    </html>
    HTML
  }

  let(:capybara_source) { Capybara.string(string_source) }

  before(:all) do
    @scraper = Beemo::Scraper.new(string_source)
  end

  describe "#initialize" do
    it "should set the correct default Capybara settings" do
      Capybara.run_server.should == false
      Capybara.current_driver.should == :webkit
      Capybara.default_selector.should == :xpath
    end
  end

  describe "using define" do
    it "should define a scraper" do
      s = Scraper.define(string_source) do
        scrape '/html/body'
      end
    end
  end

  describe "#source=" do
    before(:each) { @scraper.source = url_string_source }

    context "when the source is valid" do
      it "should assign the valid source to @source" do
        @scraper.source.should_not be_nil
        @scraper.source.should == url_string_source
      end

      it "should set the app_host as the source when passed a URL string" do
        Capybara.app_host.should be @scraper.source
        Capybara.app_host.should_not be_nil
      end

      it "should not set the app_host as the source when passed a String" do
        @scraper.source = string_source
        Capybara.app_host.should_not == @scraper.source
      end

      it "should not set the app_host as the source when passed a URI" do
        @scraper.source = uri_source
        Capybara.app_host.should_not == @scraper.source
      end
    end

    context "when the source is invalid" do
      it "should raise an ArgumentError for an invalid source type" do
        expect { @scraper.source = invalid_source_type }.to raise_error ArgumentError
      end

      it "should raise an ArgumentError for a nil source" do
        expect { @scraper.source = nil }.to raise_error ArgumentError
      end
    end

    after(:all) { @scraper.source = string_source }
  end

  describe "#select" do
    it "should reset Capybara.default_selector to :xpath after using :css" do
      @scraper.scrape('html', :css)
      Capybara.default_selector.should == :xpath
    end

    it "should raise an ArgumentError if source is nil" do
      expect {
        @scraper.source = nil
        @scraper.scrape('/html')
      }.to raise_error ArgumentError
    end
  end

  describe "#scrape_text" do
    it "should return a valid string value from the source" do
      actual = @scraper.scrape_text('//a')
      actual.should_not be_nil
      actual.should be_a String
      actual.should == "London"
    end
  end

  describe "#scrape_value" do
    it "should return a valid string value from the source" do
      actual = @scraper.scrape_value('/html/body/input')
      actual.should == "London"
    end
  end

  describe "#scrape_attribute_value" do
    it "should return a valid string value from the source" do
      actual = @scraper.scrape_attribute_value('/html/body/img', :alt)
      actual.should == "test_image"
    end
  end
end

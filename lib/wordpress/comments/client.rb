require 'nokogiri'
require 'open-uri'

module Wordpress
  module Comments
    class Client
      # returns the url of the comments resource
      attr_reader :url

      # initialize the client
      # @param [String] url the url of the comments resource
      def initialize url
        @url = url
      end

      # fetch the xml data and return the parsed object
      # @return [Array] an array of comments hashes from remote xml data
      def fetch
        xml = get @url
        parse xml
      end

      # parse xml
      # @param [XML] xml the xml data
      # @return [Array] an array of comments hashes from xml data
      def parse xml
        doc = Nokogiri::XML xml
        doc.search('item').map do |doc_item|
          item = {}
          item[:link] = doc_item.at('link').text
          item[:title] = doc_item.at('title').text
          item[:commenter] = doc_item.xpath('dc:creator').text
          item[:date] = DateTime.parse doc_item.xpath('pubDate').text
          item
        end
      end

      private

      # get remote data
      # @param [String] url the url of the comments resource
      def get url
        open url
      end

    end
  end
end
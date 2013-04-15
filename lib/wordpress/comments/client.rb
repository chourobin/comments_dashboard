require 'nokogiri'

module Wordpress
	module Comments
		class Client
			attr_reader :url

			# initialize the client
			# @param [String] the url of the comments resource
			def initialize url
				@url = url
			end

			# parse xml
			# @param [Data] the xml data
			# @return [Array] an array of comments hashes from xml data
			def parse xml
				doc = Nokogiri::XML xml
				doc.search('item').map do |doc_item|
					item = {}
					item[:link] = doc_item.at('link').text
					item[:title] = doc_item.at('title').text
					item
				end
			end

		end
	end
end
module Wordpress
	module Comments
		class Client
			attr_reader :url

			def initialize url
				@url = url
			end
		end
	end
end

#
# Specs
#
describe Wordpress::Comments::Client do

	describe "#initialize" do

		it "stores a URL" do
			client = Wordpress::Comments::Client.new "http://mashable.com/comments/feed"
			expect(client.url).to eq "http://mashable.com/comments/feed"
		end

	end

	describe "#parse" do

		let(:xml) { File.read(File.join('spec', 'fixtures', 'feed.xml')) }

		it "extracts the link" do
			client = Wordpress::Comments::Client.new "http://mashable.com/comments/feed"
			comments = client.parse xml
			comment = comments.first
			link = "http://mashable.com/2012/07/18/ipad-early-photos/comment-page-1/#comment-18239503"
			expect(comment.link).to eq link
		end

	end

end
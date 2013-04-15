module Wordpress
	module Comments
		class Client
			def initialize url

			end
		end
	end
end

#
# Specs
#
describe Wordpress::Comments::Client do

	it "stores a URL" do
		client = Wordpress::Comments::Client.new "http://mashable.com/comments/feed"
		expect(client.url).to eq "http://mashable.com/comments/feed"
	end

end
require_relative '../../../../lib/wordpress/comments/client'
require_relative '../../../support/match_date'
#
# Specs
#
describe Wordpress::Comments::Client do

  let(:client) { Wordpress::Comments::Client.new "https://peepcode.com/code/rspec/comments/feed.xml" }
  let(:xml) { File.read(File.join('spec', 'fixtures', 'feed.xml')) }

  describe "#initialize" do

    it "stores a URL" do
      expect(client.url).to eq "https://peepcode.com/code/rspec/comments/feed.xml"
    end

  end

  describe "#parse" do

    let(:comments) { client.parse xml }
    let(:comment) { comments.first }

    it "extracts the link" do
      link = "http://mashable.com/2012/07/18/ipad-early-photos/comment-page-1/#comment-18239503"
      expect(comment[:link]).to eq link
    end

    it "extracts the title" do
      title = "Comment on The Earliest Photos of Apple’s iPad Hit the Web by Fido"
      expect(comment[:title]).to eq title
    end

    it "extracts the name of the commenter" do
      expect(comment[:commenter]).to eq 'Fido'
    end

    it "extracts the date" do
      # Wed, 18 Jul 2012 22:55:57 +0000
      expect(comment[:date].year).to eq 2012
    end

    it "extracts the date (redux)" do
      # Wed, 18 Jul 2012 22:55:57 +0000
      expect(comment[:date]).to match_date '2012-07-18'
    end

  end

  describe "#fetch" do

    let(:comments) { client.fetch }

    context "success" do

      before(:each) do
        # tests pass faster
        client.stub(:get).and_return(xml) #xml
      end

      it "builds comment objects" do
        expect(comments.length).to eq 30
      end

    end

    # testing exceptions
    context "bad URL" do

      let(:client) { Wordpress::Comments::Client.new "not a url" }

      it "raise error" do
        # catches the error and passes test
        expect {
          client.fetch
        }.to raise_error(Errno::ENOENT)
      end

    end

    context "bad XML" do

      before(:each) do
        # tests pass faster
        client.stub(:get).and_return("Bad XML") #xml
      end

      it "raise error from Nokogiri" do
        expect {
          client.fetch
        }.to raise_error(Nokogiri::XML::SyntaxError)
      end

    end

  end

end
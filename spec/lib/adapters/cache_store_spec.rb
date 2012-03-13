require 'spec_helper'
  
describe Cashier::Adapters::CacheStore do
  subject { Cashier::Adapters::CacheStore }
  let(:cache) { Rails.cache }
  
  it "should store the fragment in a tag" do
    subject.store_fragment_in_tag('dashboard', 'fragment-key')
    cache.fetch('dashboard').should eql(['fragment-key'])
  end

  it "should store the tag in the tags array" do
    subject.store_tags("dashboard")
    cache.fetch(Cashier::CACHE_KEY).should eql(['dashboard'])
  end

  it "should return all of the fragments for a given tag" do
    subject.store_fragment_in_tag('dashboard', 'fragment-key')
    subject.store_fragment_in_tag('dashboard', 'fragment-key-2')
    subject.store_fragment_in_tag('dashboard', 'fragment-key-3')

    subject.get_fragments_for_tag('dashboard').length.should == 3
  end

  it "should delete a tag from the cache" do
    subject.store_fragment_in_tag('dashboard', 'fragment-key')
    Rails.cache.read('dashboard').should_not be_nil

    subject.delete_tag('dashboard')
    Rails.cache.read('dashboard').should be_nil
  end

  it "should return the list of tags" do
    (1..5).each {|i| subject.store_tags("tag-#{i}")}
    subject.tags.length.should == 5
  end

  it "should remove tags from the tags list" do
    (1..5).each {|i| subject.store_tags("tag-#{i}")}
    subject.remove_tags("tag-1", "tag-2", "tag-3", "tag-4", "tag-5")
    subject.tags.length.should == 0
  end


end
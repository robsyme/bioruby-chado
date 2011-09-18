require 'helper'
require 'bio'

describe GFF do
  it "should be able to read a gff file" do
    gff = GFF.new('test/data/random_order.gff3')
    sorted = gff.tsort.reverse
    sorted.must_be_kind_of Array
    File.open('test/data/ordered.gff3', 'w') do |file|
      file.puts sorted
    end
  end
end

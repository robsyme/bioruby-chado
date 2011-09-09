require 'helper'

describe General::DB do

  before do
    @testdb1 = General::DB.first_or_create({ :name => "testdb1",
                                            :description => "A test database for the bioruby chado schema",
                                            :urlprefix => "http://bioruby.open-bio.org/search?query=",
                                            :url => "http://bioruby.open-bio.org/"})
  end

  it "can access the database attributes via methods" do
    @testdb1.name.must_equal "testdb1"
    @testdb1.description.must_match /test database/
    @testdb1.urlprefix.must_match /bioruby/
    @testdb1.url.must_match /bioruby/
  end

  it "can create and destroy database entries" do
    @testdb2 = General::DB.first_or_create({ :name => 'testdb2',
                                            :description => 'Just another database for testing purposes',
                                            :urlprefix => 'http://www.example.com/search?query=',
                                            :url => 'http://www.example.com/'})
    @testdb2.valid?.must_equal true
    @testdb2.name.must_equal "testdb2"
    @testdb2.description.must_match /another database/
    @testdb2.urlprefix.must_match /http/
    @testdb2.url.must_match /http/
    @testdb2.db_id.must_be_kind_of Fixnum

    @testdb2.destroy.must_equal true
    General::DB.all(:name => 'testdb2').count.must_equal 0
  end

  after do
    @testdb1.destroy if @testdb1
    @testdb2.destroy if @testdb2
  end
end


describe General::DBxref do

  before do
    @genbank_db = General::DB.first_or_create({ :name => 'DB:genbank:protein',
                                           :description => 'GenBank Protein',
                                           :urlprefix => 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=search&db=protein&dopt=GenBank&term=' })
    @toxA_dbxref = General::DBxref.first_or_create({ :accession => 'EAT76059',
                                                     :version => '2',
                                                     :db => @genbank_db })
  end
  
  it 'can access the dbxref attributes' do
    @toxA_dbxref.accession.must_equal 'EAT76059'
    @toxA_dbxref.version.must_equal '2'
    @toxA_dbxref.db.must_equal @genbank_db
  end

  it 'can create and destroy a new dbxref entry' do
    @toxA_ptr_dbxref = General::DBxref.first_or_create({ :accession => 'ADY05383',
                                                         :version => '1',
                                                         :db => @genbank_db })
    @toxA_ptr_dbxref.valid?.must_equal true
    @toxA_ptr_dbxref.destroy.must_equal true
  end

  after do
    @toxA_ptr_dbxref.destroy if @toxA_ptr_dbxref
  end
end

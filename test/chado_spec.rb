
require 'helper'
require 'minitest/spec'
require 'minitest/autorun'

include Bio::Chado


DataMapper.setup(:default, {
                   :adapter => "postgres",
                   :database => "chado_test",
                   :username => "rob",
                   :password => "grayishgymnosperm",
                   :host => "localhost"})
DataMapper.finalize



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


describe CV::CV do

  before do
    
  end

  
  it "can find the sequence ontology vocab" do
    sequence = CV::CV.first(:name => "sequence")
    sequence.wont_be_nil
    sequence.name.must_equal "sequence"
  end

  it "can create and destroy new controlled vocabs" do
    test_cv = CV::CV.first_or_create({ :name => "test",
                                       :definition => "A test controlled vocabulary"})
    test_cv.wont_be_nil
    test_cv.name.must_equal "test"
    test_cv.definition.must_equal "A test controlled vocabulary"

    test_cv.valid?.must_equal true
    test_cv.destroy.must_equal true

    CV::CV.first(:name => "test", :definition => "A test controlled vocabulary").must_be_nil
  end
end

describe CV::CVTerm do

  before do
    @sequence_ontology = CV::CV.first_or_create(:name => 'sequence')
    @gene_cvterm = CV::CVTerm.first(:name => 'gene', :cv => @sequence_ontology)
  end

  
  it "can retrieve the sequenec ontology term for gene" do
    @gene_cvterm.wont_be_nil
    @gene_cvterm.name.must_equal 'gene'
    @gene_cvterm.definition.must_match /all of the sequence elements necessary to encode a functional transcript/
  end

  it "can create and destroy cvterms" do



    test_dbxref = 
    test_cvterm  = CV::CVTerm.first_or_create({ :name => "test cvterm",
                                                :definition => "Just a test, nothing to see here",
                                                :is_obsolete => false,
                                                :is_relationshiptype => false })
    test_cvterm.wont_be_nil
    test_cvterm.name.must_equal "test cvterm"
    test_cvterm.definition.must_equal "Just a test, nothing to see here"
    test_cvterm.is_obsolete.must_equal false
    test_cvterm.is_relationshiptype.must_equal false

    
    puts CV::CVTerm.first(:definition => "test_cvterm")


  end
end


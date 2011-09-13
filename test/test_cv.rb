require 'helper'

describe CV::CV do

  before do
    @sequence = CV::CV.first(:name => "sequence")
  end

  
  it "can find the sequence ontology vocab" do
    @sequence.wont_be_nil
    @sequence.name.must_equal "sequence"
  end

  it "can create and destroy new controlled vocabs" do
    @test_cv = CV::CV.first_or_create({ :name => "test",
                                       :definition => "A test controlled vocabulary"})
    @test_cv.wont_be_nil
    @test_cv.name.must_equal "test"
    @test_cv.definition.must_equal "A test controlled vocabulary"

    @test_cv.valid?.must_equal true
    @test_cv.destroy.must_equal true

    CV::CV.first(:name => "test", :definition => "A test controlled vocabulary").must_be_nil
  end

  after do
    @test_cv.destroy if @test_cv
  end
end

describe CV::CVTerm do

  before do
    @sequence_ontology = CV::CV.first_or_create(:name => 'sequence')
    @gene_cvterm = CV::CVTerm.first(:name => 'gene', :cv => @sequence_ontology)
  end

  
  it "can retrieve the sequenec ontology term for gene" do
    @sequence_ontology.wont_be_nil
    @gene_cvterm.wont_be_nil
    @gene_cvterm.name.must_equal 'gene'
    @gene_cvterm.definition.must_match /all of the sequence elements necessary to encode a functional transcript/
  end

  it "can create and destroy cvterms" do
    @test_cvterm  = CV::CVTerm.first_or_create({ :name => "test cvterm",
                                                 :definition => "Just a test, nothing to see here",
                                                 :is_obsolete => false,
                                                 :is_relationshiptype => false })
    @test_cvterm.wont_be_nil
    @test_cvterm.name.must_equal "test cvterm"
    @test_cvterm.definition.must_equal "Just a test, nothing to see here"
    @test_cvterm.is_obsolete.must_equal false
    @test_cvterm.is_relationshiptype.must_equal false
  end

  it "can easily find or create sequence ontology terms" do
    gene = CV::CVTerm.so_gene
    gene.must_be_kind_of CV::CVTerm
    gene.name.must_equal 'gene'
    gene.dbxref.accession.must_equal '0000704'
    
    proc{CV::CVTerm.so_foobar}.must_raise MissingSequenceOntologyTerm

    # You can catch the SO terms with a begin/rescue/end.
    # The error object has an instance variable "cvterm" that holds
    # the name of the mising cvterm.
    # The user might want to supply an obo file which could then be
    # scanned for the missing term which can then be added to the DB.
    begin
      CV::CVTerm.so_foobar
    rescue MissingSequenceOntologyTerm => error
      error.cvterm.must_equal "foobar"
    end
  end

  it "can easily find or create sequence ontology terms from SO accessions" do
    gene = CV::CVTerm.so_0000704
    gene.must_be_kind_of CV::CVTerm
    gene.name.must_equal 'gene'
    gene.dbxref.accession.must_equal '0000704'
  end
  
  after do
    @test_cvterm.destroy if @test_cvterm
  end
end

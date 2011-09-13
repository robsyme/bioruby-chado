require 'helper'
require 'bio'

describe Sequence::Feature do

  before do
    @gb = General::DB.first_or_create({ :name => 'DB:genbank' })
    @chrom_dbxref = General::DBxref.first_or_create({ :db => @gb,
                                                      :accession => 'CM001126',
                                                      :version => '1' })
    @yeast = Organism::Organism.first_or_create({ :genus => 'Saccharomyces',
                                                  :species => 'cerevisiae' })
    @sequence_ontology_cv = CV::CV.first_or_create({ :name => 'sequence' })
    @sequence_ontology_db = General::DB.first_or_create({ :name => 'SO' })
    @sequence_ontology_db.update(:url => 'http://www.sequenceontology.org')
    @sequence_ontology_db.update(:urlprefix => 'http://www.sequenceontology.org/browser/current_release/term/SO:')
    @chromosome_dbxref = General::DBxref.first_or_create({ :db => @sequence_ontology_db,
                                                           :accession => '0000340' })
    @chromosome_cvterm = CV::CVTerm.first_or_create({ :cv => @sequence_ontology_cv,
                                                      :dbxref => @chromosome_dbxref,
                                                      :name => 'chromosome' })
    @chromosome_cvterm.update(:definition => 'Structural unit composed of a nucleic acid molecule which controls its own replication through the interaction of specific proteins at one or more origins of replication.')
    @chrom = Sequence::Feature.first_or_create({ :dbxref => @chrom_dbxref,
                                                 :organism => @yeast,
                                                 :type => @chromosome_cvterm,
                                                 :name => 'Saccharomyces cerevisiae VL3 chromosome I, whole genome shotgun sequence.',
                                                 :uniquename => 'chromI' })
  end

  it "should be able to create a full sequence feature" do
    @gb.valid?.must_equal true
    @chrom_dbxref.valid?.must_equal true
    @yeast.valid?.must_equal true
    @sequence_ontology_cv.valid?.must_equal true
    @sequence_ontology_db.valid?.must_equal true
    @chromosome_dbxref.valid?.must_equal true
    @chromosome_cvterm.valid?.must_equal true
    @chrom.valid?.must_equal true
  end

  it "should be able to destroy the feature" do
    @chrom.destroy.must_equal true
  end

  it "should destroy its dbxref when the feature is destroyed" do
    @chrom.destroy
    General::DBxref.get(@chrom.dbxref).must_be_nil
  end

  after do
    @chrom.destroy if @chrom 
  end

end

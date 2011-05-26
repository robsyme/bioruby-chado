require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'minitest/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'bio-chado'

class MiniTest::Unit::TestCase
end

MiniTest::Unit.autorun


module DBWriter
  include Bio::Chado
  def so_db
    General::DB.first_or_create(:name => 'SO',
                                :description => 'Sequence Ontology Database',
                                :urlprefix => 'http://www.sequenceontology.org/miso/current_release/term/',
                                :url => 'http://www.sequenceontology.org')
  end

  def gene_dbxref
    dbxref = General::DBxref.first_or_create(:accession => '0000704')
    dbxref.db = so_db
    dbxref
  end

  def biological_region_dbxref
    dbxref = General::DBxref.first_or_create(:accession => '0001411')
    dbxref.db = so_db
    dbxref
  end

  def sequence_cv
    CV::CV.first_or_create(:name => 'sequence',
                           :definition => 'Sequence Ontology')
  end

  def biological_region_cvterm
    cvterm = CV::CVTerm.first_or_create(:name => 'biological_region',
                                        :definition => 'A region defined by its disposition to be involved in a biological process',
                                        :is_obsolete => 0,
                                        :is_relationshiptype => 0)
    cvterm.dbxref = biological_region_dbxref
    cvterm
  end

  def gene_cvterm
    cvterm = CV::CVTerm.first_or_create(:name => 'gene',
                                        :definition => 'A region (or regions) that includes all of the sequence elements necessary to encode a functional transcript. A gene may include regulatory regions, transcribed regions and/or other functional sequence regions.',
                                        :is_obsolete => 0,
                                        :is_relationshiptype => 0)
    cvterm.dbxref = gene_dbxref
    cvterm
  end

  def obo_rel_db
    General::DB.first_or_create(:name => 'OBO_REL')
  end

  def is_a_dbxref
    dbxref = General::DBxref.first_or_create(:accession => 'is_a')
    dbxref.db = obo_rel_db
    dbxref
  end

  def is_a_relationship
    cvterm_relationship = CV::CVTermRelationship.first_or_create(:name => 'is_a',
                                                                 :is_obsolete => 0,
                                                                 :is_relationshiptype => 1)
    cvterm_relationship.dbxref = is_a_dbxref
    cvterm_relationship
  end

end

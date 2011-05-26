require "helper"
require "data_mapper"
require "pp"
require "obo"


DataMapper.setup(:default, {
                   :adapter => 'sqlite',
                   :database => 'test/test.sqlite'})

# DataMapper.setup(:default, {
#                    :adapter => 'postgres',
#                    :username => 'testuser',
#                    :password => 'testuserpass',
#                    :host => 'localhost',
#                    :database => 'test'})
DataMapper.finalize
DataMapper.auto_migrate!

class TestGeneral < MiniTest::Unit::TestCase
  include DBWriter
  def setup
    @so_db = so_db
    @gene_dbxref = gene_dbxref
  end

  def test_db_recall
    assert_equal 'SO', @so_db.name
    assert_equal 'Sequence Ontology Database', @so_db.description
    assert_equal 'http://www.sequenceontology.org', @so_db.url
  end
end

class TestCV < MiniTest::Unit::TestCase
  DBWriter

  def setup
    @sequence_cv = sequence_cv

    @gene_dbxref = gene_dbxref
    @gene_cvterm = gene_cvterm
    
    @biological_region_dbxref = biological_region_dbxref
    @biological_region_cvterm = biological_region_cvterm

    @is_a_relationship = is_a_relationship
  end

end


class TestGOLoad < MiniTest::Unit::TestCase

  def setup
    @obo = Obo::Parser.new("test/data/ro.obo")
    @header = @obo.elements.first
  end


  def test_db_load
    ontology = Bio::Chado::CV::CV.first_or_create(:name => @header['default-namespace'],
                                                  :definition => @header['idspace'])
    assert ontology.save
    assert_equal Bio::Chado::CV::CV.first.name, "relationship"

    match = @header['idspace'].match(/(?<name>[^ ]+) (?<uri>[^ ]+) \"(?<description>.*)\"/)

    @reldb = Bio::Chado::General::DB.first_or_create(:name => match[:name],
                                                     :url => match[:uri],
                                                     :description => match[:description])

    assert @reldb.save

  end

  def test_typedef_load
    # Each cvterm needs a dbxref, which in turn needs a db.
    # We're loading relationship cvterms, so let's grab the REL_OBO db.
    match = @header['idspace'].match(/(?<name>[^ ]+) (?<uri>[^ ]+) \"(?<description>.*)\"/)

    # Go through each of the stanzas, creating the cvterm and its dbxref
    @relationship_cv = Bio::Chado::CV::CV.first(:name => "relationship")
    @obo.rewind
    @obo.elements.each do |element|
      case element
      when Obo::Header
        next
      when Obo::Stanza
        db_name, id = element.id.split(":")

        db = Bio::Chado::General::DB.first(:name => db_name)
        dbxref = Bio::Chado::General::DBxref.first_or_create(:accession => id,
                                                             :version => 1,
                                                             :description => element['def'])
        dbxref.db = db
        #pp dbxref.errors unless dbxref.valid?
        assert dbxref.save

        cvterm = Bio::Chado::CV::CVTerm.first_or_create(:name => id,
                                                        :definition => element['def'],
                                                        :is_obsolete => element['is_obsolete'],
                                                        :is_relationshiptype => 1)
        cvterm.dbxref = dbxref
        cvterm.cv = @relationship_cv
        assert cvterm.save
      end
    end
  end
end

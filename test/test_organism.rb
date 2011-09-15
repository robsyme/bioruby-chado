require 'helper'
require 'date'
require 'pp'

describe Organism::Organism do

  before do
    @yeast = Organism::Organism.first_or_create({ :abbreviation => 'S.cerevisiae',
                                                  :genus => 'Saccharomyces',
                                                  :species => 'cerevisiae',
                                                  :common_name => 'yeast'})
  end
  
  it "can access the database attributes via methods" do
    @yeast.wont_be_nil
    @yeast.abbreviation.must_equal "S.cerevisiae"
    @yeast.genus.must_equal "Saccharomyces"
    @yeast.species.must_equal "cerevisiae"
    @yeast.common_name.must_equal "yeast"
  end

  it "can create and destroy organism database entries" do
    @test_org = Organism::Organism.first_or_create({ :abbreviation => 'T.testalot',
                                                     :genus => 'Tester',
                                                     :species => 'testalot',
                                                     :common_name => 'test'})
    @test_org.valid?.must_equal true
    @test_org.destroy.must_equal true
  end

  it "can create and destroy a set of new organism properties from minimal proname => value hash " do
    @new_organism_props = @yeast.create_organismprops({ :model_organism => true,
                                                        :genome_sequence_release_date => '1996-04-24' })
    @new_organism_props.must_be_kind_of Hash
    @new_organism_props.each{|property, value| value.must_be_kind_of Organism::OrganismProp}
    @new_organism_props[:model_organism].value.must_equal "true"
    @new_organism_props[:genome_sequence_release_date].value.must_equal '1996-04-24'

    @new_organism_props.each do |property_name, property|
      property.destroy.must_equal true
    end

    @new_organism_props.each do |property_name, property|
      CV::CVTerm.get(property.type.cvterm_id).must_be_nil
      General::DBxref.get(property.type.dbxref.dbxref_id).must_be_nil
    end
  end

  after do
    @test_org.destroy if @test_org
    @new_organism_props.each do |property_name, property|
      property.destroy if property
    end if @new_organism_props
  end
end

describe Organism::OrganismDBxref do
  before do
    @yeast = Organism::Organism.first_or_create({ :abbreviation => 'S.cerevisiae',
                                                  :genus => 'Saccharomyces',
                                                  :species => 'cerevisiae',
                                                  :common_name => 'yeast'})
    @wikipedia_db = General::DB.first_or_create( :name => "Wikipedia" )
    @yeast_dbxref = General::DBxref.first_or_create({ :db => @Wikipedia_db,
                                                      :accession => "Saccharomyces_cerevisiae",
                                                      :version => 448911471 })
    @yeast_organism_dbxref = Organism::OrganismDBxref.first_or_create({ :organism => @yeast,
                                                                        :dbxref => @yeast_dbxref })
  end

  it "can access dbxref attributes through methods" do
    @yeast_organism_dbxref.organism.must_equal @yeast
    @yeast_organism_dbxref.dbxref.db.must_equal @Wikipedia_db
  end

  it "should not allow you to create organism_dbxrefs without an specifying an organism" do
    @fail_organism_dbxref = Organism::OrganismDBxref.first_or_create({ :organism => @yeast })
    @fail_organism_dbxref.valid?.must_equal false
    @fail_organism_dbxref.save.must_equal false
  end

  it "should not allow you to create an organism_dbxref without specifying a dbxref" do
    @fail_organism_dbxref = Organism::OrganismDBxref.first_or_create({ :dbxref => @yeast_dbxref })
    @fail_organism_dbxref.valid?.must_equal false
    @fail_organism_dbxref.save.must_equal false
  end

  after do
    @fail_organism_dbxref.destroy if @fail_organism_dbxref
  end
                                                                     
end

describe Organism::OrganismProp do
  # TODO: Organism properties are so rarely used, do it later.
end


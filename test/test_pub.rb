require 'helper'

describe Pub::Pub do
  before do
    # Publications need a CVTerm
    #                     CVTerm needs a CV and a DBxref
    #                                             DBxref needs a DB
    
    @fbcv_db = General::DB.first_or_create({ :name => "FBcv" })
    @paper_dbxref = General::DBxref.first_or_create({ :db => @fbcv_db,
                                                      :accession => "0000213" })
    @fbcv = CV::CV.first_or_create({ :name => "FBcv" })
    @paper_cvterm = CV::CVTerm.first_or_create({ :cv => @fbcv,
                                                 :name => "paper",
                                                 :dbxref => @paper_dbxref })
    @stago_paper = Pub::Pub.first_or_create({ :type => @paper_cvterm,
                                              :uniquename => "10.1105/tpc.107.052829",
                                              :title => "Dothideomycete plant interactions illuminated by genome sequencing and EST analysis of the wheat pathogen Stagonospora nodorum.",
                                              :volume => 19,
                                              :issue => 11 })
end

  it "can create a pub with a cvterm, cv, dbxref and db" do
    @fbcv_db.valid?.must_equal true
    @paper_dbxref.valid?.must_equal true
    @fbcv.valid?.must_equal true
    @paper_cvterm.valid?.must_equal true
    @stago_paper.valid?.must_equal true
  end

  it "can destroy the publication" do
    @stago_paper.destroy.must_equal true
  end

  it "can access publication title" do
    @stago_paper.title.must_match /Dothideomycete plant interactions illuminated by genome sequencing/
  end

  it "can access publication volume" do
    @stago_paper.volume.must_equal "19"
  end

  it "can access publication issue" do
    @stago_paper.issue.must_equal "11"
  end

  after do
    @fbcv_db.destroy
    @paper_dbxref.destroy
    @fbcv.destroy
    @paper_cvterm.destroy
    @stago_paper.destroy
  end
end

describe Pub::PubDBxref do
  before do
    
  end

  after do

  end
end

describe Pub::PubRelationship do
  before do

  end

  after do

  end
end

describe Pub::Pubauthor do
  before do

  end

  after do

  end
end

describe Pub::Pubprop do
  before do

  end

  after do

  end
end

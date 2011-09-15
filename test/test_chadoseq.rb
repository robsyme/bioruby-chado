require 'helper'
require 'bio'

describe ChadoSeq do


  before do
    @biosequence = Bio::GenBank.new(File.read('test/data/S.nodorum_scaffold_55.genbank')).to_biosequence
  end
  
  it "should be able to create a complete Feature object from a fairly complete Bio::Sequence object" do
    chadoseq = ChadoSeq.new({ :biosequence => @biosequence,
                              :type => 'supercontig'})
    chadoseq.name.must_equal @biosequence.definition
    chadoseq.seqlen.must_equal @biosequence.seq.length
    chadoseq.class.must_equal ChadoSeq
  end

  it "should take down the child dbxrefs when it is destroyed" do
    chadoseq = ChadoSeq.new({ :biosequence => @biosequence,
                              :type => 'supercontig'})
    dbxref = chadoseq.dbxref
    chadoseq.destroy
    General::DBxref.get(dbxref.dbxref_id).must_be_nil
  end

end

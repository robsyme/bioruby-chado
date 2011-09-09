module Bio
  module Chado

    # Classes in this namespace correspond to tables and views in the
    # Chado General module.
    
    module General

      # A database authority. Typical databases in bioinformatics are
      # FlyBase, GO, UniProt, NCBI, MGI, etc. The authority is
      # generally known by this shortened form, which is unique within
      # the bioinformatics and biomedical realm. To Do - add support
      # for URIs, URNs (e.g. LSIDs). We can do this by treating the
      # URL as a URI - however, some applications may expect this to
      # be resolvable - to be decided.
      
      class DB
        include DataMapper::Resource
        storage_names[:default] = 'db'

        property :db_id, Serial
        property :name, String
        property :description, String
        property :urlprefix, String
        property :url, String

        has n, :dbxrefs, 'DBxref', :child_key => [:db_id]
      end

      # A unique, global, public, stable identifier. Not necessarily
      # an external reference - can reference data items inside the
      # particular chado instance being used. Typically a row in a
      # table can be uniquely identified with a primary identifier
      # (called dbxref_id); a table may also have secondary
      # identifiers (in a linking table <T>_dbxref). A dbxref is
      # generally written as <DB>:<ACCESSION> or as
      # <DB>:<ACCESSION>:<VERSION>.
      
      class DBxref
        include DataMapper::Resource
        storage_names[:default] = 'dbxref'
        
        property :dbxref_id, Serial
        property :accession, String
        property :version, String
        property :description, Text

        has n, :cvterms, 'Bio::Chado::CV::CVTerm', :child_key => [:dbxref_id]
        has n, :features, 'Bio::Chado::Sequence::Feature', :child_key => [:dbxref_id]
        has n, :feature_cvterm_dbxrefs, 'Bio::Chado::Sequence::FeatureCVTermDBxref', :child_key => [:dbxref_id]
        
        belongs_to :db, 'DB', :child_key => [:db_id]
      end

    end
  end
end

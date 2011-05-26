module Bio
  module Chado
    module General

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

      class DBxref
        include DataMapper::Resource
        storage_names[:default] = 'dbxref'
        
        property :dbxref_id, Serial
        property :accession, String
        property :version, String
        property :description, Text

        has n, :cvterms, 'Bio::Chado::CV::CVTerm', :child_key => [:dbxref_id]

        belongs_to :db, 'DB', :child_key => [:db_id]
      end

    end
  end
end

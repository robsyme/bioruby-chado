module Bio
  class Chado
    module General
      class DB
        include DataMapper::Resource

        property :id, Serial
        property :name, String
        property :description, String
        property :urlprefix, String

        has n, :dbxrefs
      end

      class DBxref
        include DataMapper::Resource

        property :id, Serial
        property :accession, String
        property :version, String
        property :description, Text

        belongs_to :db
      end
    end
  end
end

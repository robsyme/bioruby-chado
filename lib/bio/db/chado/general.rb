module Bio
  module Chado
    module General
      class DB
        include DataMapper::Resource

        property :id, Serial
        property :name, String
        property :description, String
        property :urlprefix, String
      end
    end
  end
end

# -*- coding: utf-8 -*-
# This is just a test to see if I can get the rdoc to be generated

module Bio
  module Chado

    # Classes in this namespace correspond to tables and views in the
    # Chado Organism module.
    
    module Organism

      # The organismal taxonomic classification. Note that phylogenies
      # are represented using the phylogeny module, and taxonomies can
      # be represented using the cvterm module or the phylogeny
      # module.
      # 
      # Required properties for creating new {Organism} are:
      # - genus - String
      # - species - String
      
      class Organism
        include DataMapper::Resource
        storage_names[:default] = 'organism'

        property :organism_id, Serial
        property :abbreviation, String
        property :genus, String
        property :species, String
        property :common_name, String
        property :comment, Text

        # TODO: has_many :features, 'Sequence::Feature', :child_key[:organism_id]

        
        has n, :organism_dbxrefs, 'OrganismDBxref', :child_key => [:organism_id]
        has n, :organism_props, 'OrganismProp', :child_key => [:organism_id]
        has n, :features, 'Sequence::Feature', :child_key => [:organism_id]


        # Create a new organism property. Each new organismprop needs
        # a rank, a value and a {CV::CVTerm type}. The type has
        # properties for a name, definition, {General::DBxref dbxref}
        # and a {CV::CV controlled vocabulary}. The CV just needs a
        # name + definition, and the dbxref needs an accession, a
        # version, a description and a db. The db can take a name,
        # description, urlprefix and a url:
        #
        #     OrganismProp
        #     ├ rank - created automatically
        #     ├ value
        #     └ type (CV::CVTerm)
        #       ├ name
        #       ├ definition
        #       ├ dbxref (General::DBxref)
        #       │ ├ accession
        #       │ ├ version
        #       │ ├ description
        #       │ └ db (General::DB)
        #       │   ├ name
        #       │   ├ description
        #       │   ├ urlprefix
        #       │   └ url
        #       └ cv (CV::CV)
        #         ├ name
        #         └ definition
        #
        # I think that it's fair to assume the user has already
        # created a db and cv to hold the new properties, but that the
        # method should create the CVTerm and DBxref automatically
        #
        # The user should also be able to give an existing CVTerm,
        # which would eliminate the need to specify the dbxref as
        # well. If the user doesn't give a dbxref, it should be
        # created for them, using version=1, description="",
        # accession="autocreated_" + value.
        #
        # @param [String] property_name The name (CVTerm name) of the new organism property.
        # @param [General::DB] db The {General::DB} that this property's dbxref should belong to.
        # @param [CV::CV] cv The {CV::CV} object that the property belongs to.
        # @param [String] value The value of the new organism property
        # @option opts [String] :definition ('') A human-readable text definition for the {CV::CVTerm}
        # @option opts [String] :dbxref_description ('') The description used for the dbxref
        # @option opts [String] :dbxref_accession ('autocreated_' + property_name) The local part of the identifier.
        # @option opts [String] :dbxref_version ('1') The dbxref version.
        # @option opts [Integer] :rank The property rank. This will auto-increment. 
        
        def create_organismprop(db, cv, opts={})
          defaults = {
            :definition => '',
            :dbxref_description => nil,
            :dbxref_accession => nil,
            :dbxref_version => '1',
            :rank => OrganismProp.all(:organism => self).count + 1}

          options = defaults.merge(opts)
          properties = options.reject{|key,value| defaults.keys.include?(key)}

          property_name, property_value = properties.first
          options[:dbxref_accession] = "autocreated_#{property_name}" unless options[:dbxref_accession]
          $stderr.puts "WARNING: more than one property defined. Only using '#{property_name}'" if properties.length > 1

          dbxref = General::DBxref.first_or_create({ :db => db,
                                                     :version => options[:dbxref_version],
                                                     :accession => options[:dbxref_accession] })
          dbxref.update(:description => options[:dbxref_description])
          
          cvterm = CV::CVTerm.first_or_create({ :dbxref => dbxref,
                                                :cv => cv,
                                                :definition => options[:definition],
                                                :name => property_name })

          property_count = OrganismProp.all(:organism => self).count
          property = OrganismProp.first_or_create({ :organism => self,
                                         :type => cvterm,
                                         :value => property_value })
          property.update(:rank => options[:rank])
          property
        end
      end

      
      # Required properties for creating new {OrganismDBxref} are:
      # - organism - {Organism::Organism}
      # - dbxref - {General::DBxref}

      class OrganismDBxref
        include DataMapper::Resource
        storage_names[:default] = 'organism_dbxref'

        property :organism_dbxref_id, Serial

        belongs_to :organism, 'Organism', :child_key => [:organism_id]
        belongs_to :dbxref, 'General::DBxref', :child_key => [:dbxref_id]
      end


      # When an OrganismProp is destroyed, it checks to see if any
      # other objects are using the same type
      # ({CV::CVTerm}). If it is the last property using
      # that type, it deletes the {CV::CVTerm CVTerm} as well. I prefer to keep the
      # database free of orphaned {CV::CVTerm CVTerms}, but I'm happy to add the
      # option of keeping the {CV::CVTerm CVTerms} if people would prefer that.
      # 
      # Required properties for creating new {OrganismProp} are:
      # - organism - {Organism::Organism}
      # - type - {CV::CVTerm}
      # - rank - Integer

      class OrganismProp
        include DataMapper::Resource
        storage_names[:default] = 'organismprop'

        property :organismprop_id, Serial
        property :value, Text
        property :rank, Integer

        belongs_to :organism, 'Organism', :child_key => [:organism_id]
        belongs_to :type, 'CV::CVTerm', :child_key => [:type_id]

        after :destroy do |organism_prop|
          if OrganismProp.all(:type => organism_prop.type).count == 0
            organism_prop.type.destroy
          end
        end
      end

    end
  end
end

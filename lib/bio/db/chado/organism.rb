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
      
      class Organism
        include DataMapper::Resource
        storage_names[:default] = 'organism'

        property :organism_id, Serial
        property :abbreviation, String
        property :genus, String
        property :species, String
        property :common_name, String
        property :comment, Text

        # TODO: has_many :features, 'Bio::Chado::Sequence::Feature', :child_key[:organism_id]

        
        has n, :organism_dbxrefs, 'OrganismDBxref', :child_key => [:organism_id]
        has n, :organism_props, 'OrganismProp', :child_key => [:organism_id]
        has n, :features, 'Bio::Chado::Sequence::Feature', :child_key => [:organism_id]


        # convenience method to create organism properties using
        # cvterms from the ontology with the given name.
        # Accepts a hash or options.
        #
        # The options hash takes organism properties in the form
        # property_name => value.
        # 
        #
        # @param [Hash] opts of options.
        #   Defaults are:
        #   :autocreate => false
        #   :cv_name => 'organism_property'
        #   :db_name => 'null'
        #   :dbxref_accession_prefix => 'autocreated_'
        #   :definitions => {}
        #   :accessions => {}
        #   :versions => {}
        #   :allow_duplicate_values => false
        # @return [Hash] Hash of property_name => OrganismProp
        # @example The organism is a model organism
        #   yeast.create_organismprops({ :model_organism => true,
        #                                :db_name => 'Wikipedia',
        #                                :accessions => {:model_organism => "Model_organism"}})
        def create_organismprops(opts={})
          default_opts = {
            :autocreate => false,
            :cv_name => 'organism_property',
            :db_name => 'null',
            :dbxref_accession_prefix => 'autocreated_',
            :definitions => {},
            :accessions => {},
            :versions => {},
            :allow_duplicate_values => false
          }

          new_opts = default_opts.merge(opts)
          organism_props = opts.reject{|key,value| default_opts.keys.include? key }


          db = General::DB.first_or_create(:name => new_opts[:db_name])
          cv = CV::CV.first_or_create(:name => new_opts[:cv_name])
          final_hash = Hash.new
          
          organism_props.map do |property_name, value|
            dbxref_accession = new_opts[:accessions][property_name] || new_opts[:dbxref_accession_prefix] + property_name.to_s
            cvterm_version = new_opts[:versions][property_name]
            cvterm_definition = new_opts[:definitions][property_name]

            cvterm_dbxref = General::DBxref.first_or_create({ :db => db,
                                                              :accession => dbxref_accession,
                                                              :version => 1 })

            cvterm = CV::CVTerm.first_or_create({ :cv => cv,
                                                  :name => property_name,
                                                  :definition => cvterm_definition,
                                                  :dbxref => cvterm_dbxref  })
            
            prop = OrganismProp.first_or_create({ :organism => self,
                                                  :type => cvterm,
                                                  :value => value })
            final_hash[property_name] = prop
          end
          final_hash
        end
      end

      class OrganismDBxref
        include DataMapper::Resource
        storage_names[:default] = 'organism_dbxref'

        property :organism_dbxref_id, Serial

        belongs_to :organism, 'Organism', :child_key => [:organism_id]
        belongs_to :dbxref, 'Bio::Chado::General::DBxref', :child_key => [:dbxref_id]
      end

      class OrganismProp
        include DataMapper::Resource
        storage_names[:default] = 'organismprop'

        property :organismprop_id, Serial
        property :value, Text
        property :rank, Integer

        belongs_to :organism, 'Organism', :child_key => [:organism_id]
        belongs_to :type, 'Bio::Chado::CV::CVTerm', :child_key => [:type_id]

        after :destroy do |organism_prop|
          if OrganismProp.all(:type => organism_prop.type).count == 0
            organism_prop.type.destroy
          end
        end
      end

    end
  end
end

require 'delegate'
require 'digest/md5'

module Bio
  module Chado

    class ChadoSeq < DelegateClass(Sequence::Feature)

      def initialize(opts={:type => 'sequence_feature'})
        feature = Sequence::Feature.new
        feature = biosequence_to_chadoseq(opts[:biosequence], opts) if opts[:biosequence]
        super(feature)
      end

      def biosequence_to_chadoseq(biosequence, opts)
        @opts = opts
        feature = Sequence::Feature.first_or_create({ :organism => first_or_create_organism(biosequence),
                                                      :uniquename => biosequence.entry_id,
                                                      :type => first_or_create_cvterm(biosequence) })

        feature.update(:name => biosequence.definition) if biosequence.definition

        unless @opts[:no_dbxref]
          feature.update(:dbxref => first_or_create_dbxref(biosequence))
        end

        unless biosequence.seq == ""
          feature.update(:residues => biosequence.seq)
          feature.update(:seqlen => biosequence.seq.length)
          feature.update(:md5checksum => Digest::MD5.hexdigest(biosequence.seq))
        end

        feature.update(:is_analysis => opts[:is_analysis]) if opts[:is_analysis]
        feature.update(:is_obsolete => opts[:is_obsolete]) if opts[:is_obsolete]

        create_subfeatures(biosequence)
        
        feature
      end

      def create_subfeatures(biosequence)
        
      end
      
      private
      
      def first_or_create_organism(biosequence)
        check_completeness(biosequence)
        genus, *species = biosequence.species.split(" ")
        organism = Organism::Organism.first_or_create({ :genus => genus,
                                                        :species => species.join(" ") })
        organism.update(:common_name => opts[:organism_common_name]) if @opts[:organism_common_name]
        organism.update(:comment => @opts[:organism_comment]) if @opts[:organism_comment]
        organism.update(:abbreviation => @opts[:organism_abbreviation]) if @opts[:organism_abbreviation]

        organism
      end

      def check_completeness(biosequence)
        raise IncompleteBiosequenceError, biosequence if biosequence.species == "" or biosequence.species.nil?
      end

      def first_or_create_cvterm(biosequence)
        cv = first_or_create_cv
        cvterm = CV::CVTerm.first({ :cv => cv,
                                    :name => @opts[:type] })
        unless cvterm
          dbxref = first_or_create_db_with_opts_prefix("cvterm_dbxref_db")
          cvterm = CV::CVTerm.create({ :cv => cv,
                                       :name => @opts[:type],
                                       :dbxref => dbxref })
        end
        cvterm
      end

      def first_or_create_dbxref(biosequence)
        db = first_or_create_db_with_opts_prefix("dbxref_db")

        dbxref = General::DBxref.first_or_create({ :db => db,
                                                   :accession => biosequence.primary_accession,
                                                   :version => biosequence.entry_version || '' })
        dbxref.update(:description => @opts[:dbxref_description]) if @opts[:dbxref_description]
        dbxref
      end

      def first_or_create_db_with_opts_prefix(prefix = "")
        name, *rest = %w{name description urlprefix url}.map do |base|
          (prefix + "_" + base).intern
        end
        db = General::DB.first_or_create({ :name => @opts[name] || 'null' })
        rest.each do |symbol|
          db.update(symbol => @opts[symbol]) if @opts[symbol]
        end
        db
      end

      def first_or_create_cv
        CV::CV.first_or_create({ :name => @opts[:cvterm_cv_name] || 'sequence' })
      end

    end
  end
end











module Bio
  module Chado

    
    class EntryMissingError < StandardError; end

    class SequenceOntologyCVMissing < EntryMissingError
      def initialize(msg="No 'sequence' entry in the 'cv' table")
        super(msg)
      end
    end
    
    class MissingSequenceOntologyTerm < EntryMissingError
      attr_reader :cvterm
      def initialize(cvterm_name)
        @cvterm = cvterm_name
        super("No CVTerm '#{cvterm_name}' found from the 'sequence' controlled vocabulary")
      end
    end

    
    # An error thrown if the user attempts to convert an incomplete
    # Bio::Sequence object into a Chado record.
    #
    # Chado is no lightweight schema. This means that we have to be
    # judicious about what sequences we can let in. At a bare minimum,
    # the sequence object needs:
    # - a species id that matches a species in the database
    # - an entry_id that we can use as the record uniquename.
    
    class IncompleteBiosequenceError < StandardError
      attr_reader :errors
      def initialize(biosequence)
        @errors = []
        
        @errors << "species variable must not be nil or blank" if biosequence.species == "" or biosequence.species.nil?
        @errors << "entry_id variable must not be nil or blank" if biosequence.entry_id == "" or biosequence.entry_id.nil?
        
        msg = "Chado need to know quite a lot about a sequence before it can be stored\n"
        msg << "Try fixing up the following and trying again:\n"
        msg << @errors.map{|error| "  " + error}.join("\n")
        super(msg)
      end
    end
    
  end
end

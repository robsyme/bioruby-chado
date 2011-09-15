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

  end
end

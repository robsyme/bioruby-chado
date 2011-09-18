module Bio
  module Chado

    class GFF
      include TSort

      PARENT_FINDER = /Parent=(?<parent>[^;\n]+)[;\n]/
      ID_FINDER = /ID=(?<id>[^;\n]+)[;\n]/
      
      def initialize(filename)
        @filename = filename
        @index = index_file
      end

      def gff_lines
        Enumerator.new do |yielder|
          fasta_reached = false
          byte_index = 0
          File.open(@filename, 'r') do |file|
            file.each_line do |line|
              fasta_reached = line.match(/^##FASTA/) unless fasta_reached
              next if line.match(/^#/)
              yielder << [byte_index, line] unless fasta_reached
              byte_index = file.pos
            end
          end
        end
      end

      def index_file
        index = Hash.new{|h,k| h[k] = []}
        gff_lines.each do |byte_index, line|
          parent_match = line.match PARENT_FINDER
          next unless parent_match
          index[parent_match[:parent]] << byte_index
        end
        index
      end

      def tsort_each_node(&block)
        gff_lines.each do |file, line|
          yield line
        end
      end

      def tsort_each_child(node,&block)
        file = File.open(@filename, 'r')
        node_match = node.match ID_FINDER
        @index[node_match[:id]].each do |line_index|
          file.pos = line_index
          yield file.gets
        end
        file.close
      end
    end
  end
end

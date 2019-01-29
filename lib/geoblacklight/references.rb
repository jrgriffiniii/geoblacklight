module Geoblacklight
  class References
    attr_reader :metadata_refs, :webservice_refs, :download_refs, :reference_field
    def initialize(document, reference_field = nil)
      @document = document
      @reference_field = reference_field
      @refs = parse_references.map { |ref| Reference.new(ref) }
    end

    ##
    # Return only those metadata references which are exposed within the configuration
    # @return [Geoblacklight::Reference]
    def shown_metadata_refs; end

    ##
    # Return only metadata for shown metadata
    # @return [Geoblacklight::Metadata::Base]
    def shown_metadata; end

    ##
    # Accessor for a document's file format
    # @return [String] file format for the document
    def format
      @document[Settings.FIELDS.FILE_FORMAT]
    end

    ##
    # @param [String, Symbol] ref_type
    # @return [Geoblacklight::Reference]
    def references(ref_type)
      @refs.find { |reference| reference.type == ref_type }
    end

    ##
    # Preferred download (should be a file download)
    # @return [Hash, nil]
    def preferred_download; end

    ##
    # Download hash based off of format type
    # @return [Hash, nil]
    def downloads_by_format; end

    ##
    # Generated download types from wxs services
    # @return (see #downloads_by_format)
    def download_types; end

    private

      ##
      # Parses the references field of a document
      # @return [Hash]
      def parse_references
        if @document[reference_field].nil?
          {}
        else
          JSON.parse(@document[reference_field])
        end
      end

      ##
      # Adds a call to references for defined URI keys
      def method_missing(m, *args, &b)
        if Geoblacklight::Constants::URI.key?(m)
          references m
        else
          super
        end
      end
end

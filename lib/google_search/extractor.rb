# frozen_string_literal: true

require "charlock_holmes"
require "nokolexbor"

module GoogleSearch
  # Extractor class for extracting search results
  class Extractor
    HTML_SOURCE_MAPPING_REGEX = /window\.jsl\.dh\('(?<id>[^']+)'\s*,\s*'(?<html>[^']+)'\);/i
    IMAGE_SOURCE_MAPPING_REGEX = /var\s+s\s*=\s*'(?<src>data:[^']+)';\s*var\s+ii\s*=\s*\['(?<id>[^']+)'\];/i

    def initialize(html, strategies: nil)
      @html = transcode_to_utf8(html)
      @page = Nokolexbor::HTML(@html)
      @strategies = strategies || GoogleSearch::Strategies.all

      raise GoogleSearch::InvalidPageError unless valid_page?

      replace_html_mappings!
      replace_image_mapping!
    end

    def extract!
      @result = []

      @strategies.each do |strategy_class|
        strategy = strategy_class.new(@page)

        next unless strategy.matches?

        @result += strategy.extract!
      end

      @result
    end

    def result
      extract! if @result.nil?

      @result
    end

    protected

    # Replace HTML mappings in the page source with the actual HTML content
    # do this before extracting results to ensure we're working with a
    # "resolved-enough" page. Could do this with a proper JS engine but
    # this is a lot simpler and good enough for the purposes of this challenge.
    def replace_html_mappings!
      @page.inner_html.scan(HTML_SOURCE_MAPPING_REGEX).each do |match|
        html_id, html_source = match

        @target_element = @page.at_css("##{html_id}")

        next if @target_element.nil?

        @target_element.inner_html = resolve_escape_sequences(html_source)
      end
    end

    # Similar to above, replacing source mappings with the actual image source
    def replace_image_mapping!
      @page.inner_html.scan(IMAGE_SOURCE_MAPPING_REGEX).each do |match|
        image_source, image_id = match

        @target_element = @page.at_css("##{image_id}")

        next if @target_element.nil?

        @target_element["src"] = resolve_escape_sequences(image_source)
      end
    end

    # Resolve escape sequences in a source string where it's been extracted
    # from a JS string
    def resolve_escape_sequences(source)
      source.gsub(/\\(x[0-9a-f]{2}|u[0-9a-f]{4})/i) do |escape_match|
        escape_match[2..].to_i(16).chr(Encoding::UTF_8)
      end
    end

    # Transcode the source to UTF-8 if it's not already, this should avoid issues with bad
    # characters coming in if the source string wasn't encoded correctly to begin with
    def transcode_to_utf8(source)
      detector = CharlockHolmes::EncodingDetector.new
      detection = detector.detect(source)

      CharlockHolmes::Converter.convert(source, detection[:encoding], "UTF-8")
    end

    # Rough validation to ensure we're on a search results page
    def valid_page?
      return false if @page.nil?
      return false if @page.at_css("[itemtype=\"http://schema.org/SearchResultsPage\"]").nil?
      return false if @page.at_css("[name=\"q\"]").nil?

      true
    end
  end
end

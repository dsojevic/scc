# frozen_string_literal: true

require "uri"

module GoogleSearch
  module Strategies
    # Base strategy class for extracting search results
    class Base
      BASE_64_1X1_IMAGE = "data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=="

      def initialize(page)
        @page = page
      end

      def matches?
        false
      end

      def extract!
        return [] unless matches?

        raise NotImplementedError
      end

      def result
        extract! if @result.nil?

        @result
      end

      protected

      # Extract base URL from the page if available (in the event of non-`.com` results),
      # otherwise fallback to the primary `google.com` domain
      def base_url
        @base_url ||= @page.at_css("base")&.attr("href") || "https://www.google.com/"
      end

      # Build a full URL from a path - if the path is relative, join it with the base URL,
      # otherwise just return it as is.
      def build_url(path)
        if path.start_with?("/")
          URI.join(base_url, path).to_s
        else
          path
        end
      end

      def extract_extensions_from_nodes(nodes)
        nodes.map(&:text)&.map(&:strip)&.reject(&:empty?)
      end

      def extract_image_src(node)
        image_node = node.name == "img" ? node : node.at_css("img")
        image_src = image_node.attr("src") || image_node.attr("data-src")

        return nil if image_src == BASE_64_1X1_IMAGE
        return nil unless image_src.start_with?("data:")

        image_src
      end
    end
  end
end

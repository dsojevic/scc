# frozen_string_literal: true

module GoogleSearch
  module Strategies
    # Strategy class for extracting carousel items from search results
    class CarouselItems < Base
      ANCHOR_DATA = Struct.new(:name, :extensions)
      ITEM_SELECTOR = ".appbar g-scrolling-carousel a:has(g-img)"
      ITEM_TITLE_SELECTOR = ".kltat, .klitem > div > :nth-child(3) > :nth-child(1)"
      ITEM_EXTENSIONS_SELECTOR = ".klmeta"

      def matches?
        !@page.at_css(ITEM_SELECTOR).nil?
      end

      def extract!
        @page.css(ITEM_SELECTOR).map do |item|
          item_title = item.at_css(ITEM_TITLE_SELECTOR)
          item_image = item.at_css("img")
          item_extensions = item.css(ITEM_EXTENSIONS_SELECTOR)

          item_anchor_data = extract_name_and_extensions_from_anchor_node(item)

          item_title_text = item_anchor_data ? item_anchor_data.name : item_title.text
          item_extensions_list = item_anchor_data ? item_anchor_data.extensions : extract_extensions_from_nodes(item_extensions)

          {
            name: item_title_text,
            image: extract_image_src(item_image),
            link: build_url(item.attr("href")),
          }.merge(
            {
              extensions: item_extensions_list,
            }.compact
          )
        end
      end

      protected

      # Attempt to extract name and extensions from anchor node where available
      def extract_name_and_extensions_from_anchor_node(node)
        item_title = node.at_css(".klitem")&.attr("title") || node.attr("title").to_s
        item_name_text = node.attr("data-entityname") || node.attr("aria-label").to_s

        return nil if item_title.empty? && item_name_text.empty?

        item_extensions = extract_extensions_from_title(item_title, name: item_name_text)

        ANCHOR_DATA.new(
          item_name_text,
          item_extensions
        )
      end

      # Extract extensions array from title.
      # Format of title is "Name (Extension)"
      def extract_extensions_from_title(title, name:)
        return nil if title.empty? || name.empty? || title == name

        extensions = title[name.length..].sub(/^\s*\((.*)\)\s*$/i, '\\1')

        return nil if extensions.empty?

        [extensions]
      end
    end
  end
end

# frozen_string_literal: true

module GoogleSearch
  module Strategies
    # Strategy class for extracting grid items from search results
    class GridItems < Base
      ITEM_SELECTOR = "[data-attrid^=\"kc:\"]:has(wp-grid-tile):has(> div > a)"
      ITEM_TITLE_SELECTOR = "wp-grid-tile > :nth-child(2) > :nth-child(1)"
      ITEM_EXTENSIONS_SELECTOR = "wp-grid-tile > :nth-child(2) > :nth-child(n + 2)"

      def matches?
        !@page.at_css(ITEM_SELECTOR).nil?
      end

      def extract!
        @page.css(ITEM_SELECTOR).map do |item|
          item_anchor = item.at_css("a")
          item_title = item.at_css(ITEM_TITLE_SELECTOR)
          item_extensions = item.css(ITEM_EXTENSIONS_SELECTOR)

          {
            name: item.attr("title") || item_title.text,
            extensions: extract_extensions_from_nodes(item_extensions),
            image: extract_image_src(item),
            link: build_url(item_anchor.attr("href")),
          }
        end
      end
    end
  end
end

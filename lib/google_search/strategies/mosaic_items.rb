# frozen_string_literal: true

module GoogleSearch
  module Strategies
    # Strategy class for extracting mosaic items from search results
    class MosaicItems < Base
      ITEM_SELECTOR = "[data-attrid^=\"kc:\"] a:has(img)"
      ITEM_EXTENSIONS_SELECTOR = "img + div > :nth-child(n + 2)"

      def matches?
        !@page.at_css(ITEM_SELECTOR).nil?
      end

      def extract!
        @page.css(ITEM_SELECTOR).map do |item|
          item_image = item.at_css("img")
          item_extensions = item.css(ITEM_EXTENSIONS_SELECTOR)

          {
            name: item_image.attr("alt"),
            extensions: extract_extensions_from_nodes(item_extensions),
            image: extract_image_src(item_image),
            link: build_url(item.attr("href")),
          }
        end
      end
    end
  end
end

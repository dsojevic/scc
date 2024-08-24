# frozen_string_literal: true

module GoogleSearch
  module Strategies
    # Strategy class for extracting carousel items from search results
    class CarouselItems < Base
      ITEM_SELECTOR = ".appbar g-scrolling-carousel a:has(g-img)"
      ITEM_TITLE_SELECTOR = ".kltat"
      ITEM_EXTENSIONS_SELECTOR = ".klmeta"

      def matches?
        !@page.at_css(ITEM_SELECTOR).nil?
      end

      def extract!
        @page.css(ITEM_SELECTOR).map do |item|
          item_title = item.at_css(ITEM_TITLE_SELECTOR)
          item_image = item.at_css("img")
          item_extensions = item.css(ITEM_EXTENSIONS_SELECTOR)

          {
            name: item_title.text,
            image: extract_image_src(item_image),
            link: build_url(item.attr("href")),
          }.merge(
            {
              extensions: extract_extensions_from_nodes(item_extensions),
            }.compact
          )
        end
      end
    end
  end
end

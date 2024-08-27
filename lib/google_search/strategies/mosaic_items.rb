# frozen_string_literal: true

module GoogleSearch
  module Strategies
    # Strategy class for extracting mosaic items from search results
    class MosaicItems < Base
      UNDESIRABLE_ANCESTORS = [
        "g-scrolling-carousel",
        "[data-attrid^=\"action:\"]",
        "[data-attrid=\"kc:/common/topic:social media presence\"]",
      ].freeze

      ITEM_SELECTOR = "[data-attrid^=\"kc:\"]:not([data-attrid*=\"_actions_\"]) a:has(img):not(:has(wp-grid-tile))"
      ITEM_TITLE_SELECTOR = ".title"
      ITEM_EXTENSIONS_SELECTOR = "img + div > :nth-child(n + 2), .title + div > span"

      def matches?
        first_match = @page.at_css(ITEM_SELECTOR)

        return false if first_match.nil?
        return false if UNDESIRABLE_ANCESTORS.any? { |selector| first_match.ancestors(selector).any? }

        true
      end

      def extract!
        @page.css(ITEM_SELECTOR).map do |item|
          next if UNDESIRABLE_ANCESTORS.any? { |selector| item.ancestors(selector).any? }

          item_image = item.at_css("img")
          item_title = item.at_css(ITEM_TITLE_SELECTOR)
          item_extensions = item.css(ITEM_EXTENSIONS_SELECTOR)

          {
            name: item_title&.text || item_image.attr("alt"),
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

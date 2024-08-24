# frozen_string_literal: true

module GoogleSearch
  # Main Strategies module
  module Strategies
    autoload(:Base, './lib/google_search/strategies/base.rb')
    autoload(:CarouselItems, './lib/google_search/strategies/carousel_items.rb')
    autoload(:GridItems, './lib/google_search/strategies/grid_items.rb')
    autoload(:MosaicItems, './lib/google_search/strategies/mosaic_items.rb')

    def self.all
      [
        GoogleSearch::Strategies::CarouselItems,
        GoogleSearch::Strategies::GridItems,
        GoogleSearch::Strategies::MosaicItems,
      ]
    end
  end
end

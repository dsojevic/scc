# frozen_string_literal: true

# Main GoogleSearch module
module GoogleSearch
  class InvalidPageError < StandardError; end

  autoload(:Extractor, './lib/google_search/extractor.rb')
  autoload(:Strategies, './lib/google_search/strategies.rb')
end

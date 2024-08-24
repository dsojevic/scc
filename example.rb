#!/usr/bin/env ruby

# frozen_string_literal: true

require "json"
require_relative "./lib/google_search"

puts JSON.pretty_generate(GoogleSearch::Extractor.new(
  File.read("./spec/fixtures/john-wick-actors-search-grid/page.html"),
  strategies: [GoogleSearch::Strategies::GridItems]
).result)

puts JSON.pretty_generate(GoogleSearch::Extractor.new(
  File.read("./spec/fixtures/van-gogh-paintings-search-mosaic/page.html"),
  strategies: [GoogleSearch::Strategies::MosaicItems]
).result)

puts JSON.pretty_generate(GoogleSearch::Extractor.new(
  File.read("./spec/fixtures/van-gogh-paintings-search-carousel/page.html"),
  strategies: [GoogleSearch::Strategies::CarouselItems]
).result)

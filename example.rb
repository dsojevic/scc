#!/usr/bin/env ruby

# frozen_string_literal: true

require "json"
require_relative "./lib/google_search"

# Carousel items example, using only carousel strategy
puts JSON.pretty_generate(GoogleSearch::Extractor.new(
  File.read("./spec/fixtures/van-gogh-paintings-search-carousel/page.html"),
  strategies: [GoogleSearch::Strategies::CarouselItems]
).result)

# Carousel items example (Google Japan), using only carousel strategy
puts JSON.pretty_generate(GoogleSearch::Extractor.new(
  File.read("./spec/fixtures/one-piece-characters-japan-search-carousel/page.html"),
  strategies: [GoogleSearch::Strategies::CarouselItems]
).result)

# Grid items example, using only grid strategy
puts JSON.pretty_generate(GoogleSearch::Extractor.new(
  File.read("./spec/fixtures/john-wick-actors-search-grid/page.html"),
  strategies: [GoogleSearch::Strategies::GridItems]
).result)

# Mosaic items example, using only mosaic strategy
puts JSON.pretty_generate(GoogleSearch::Extractor.new(
  File.read("./spec/fixtures/van-gogh-paintings-search-mosaic/page.html"),
  strategies: [GoogleSearch::Strategies::MosaicItems]
).result)

# Mixed items example, using all strategies
puts JSON.pretty_generate(GoogleSearch::Extractor.new(
  File.read("./spec/fixtures/van-gogh-paintings-search-mosaic/page.html"),
  strategies: GoogleSearch::Strategies.all
).result)

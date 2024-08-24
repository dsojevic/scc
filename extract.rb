#!/usr/bin/env ruby

# frozen_string_literal: true

require "json"
require_relative "./lib/google_search"

source_file = ARGV[0] || "./spec/fixtures/van-gogh-paintings-search-carousel/page.html"
strategies = []

ARGV[1..]&.each do |flag|
  case flag.downcase
  when "--carousel"
    strategies << GoogleSearch::Strategies::CarouselItems
  when "--grid"
    strategies << GoogleSearch::Strategies::GridItems
  when "--mosaic"
    strategies << GoogleSearch::Strategies::MosaicItems
  when "--all"
    strategies = GoogleSearch::Strategies.all
  end
end

strategies = GoogleSearch::Strategies.all if strategies.empty?
strategies = strategies.uniq

puts JSON.pretty_generate(
  GoogleSearch::Extractor.new(
    File.read(source_file),
    strategies: strategies
  ).result
)

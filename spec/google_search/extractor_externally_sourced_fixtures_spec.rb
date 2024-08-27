# frozen_string_literal: true

require "spec_helper"

EXTERNALLY_SOURCED_FIXTURES = {
  "andypple83" => %w[
    john-lennon
    ruby-books
  ],
  "dev-amirson" => %w[
    cricket-teams
  ],
  "fsndzomga" => %w[
    american-presidents
    cast-of-friends
    jennifer-aniston
  ],
  "ilyazub" => %w[
    ilya-repin-paintings
  ],
  "mariusio" => %w[
    da-vinci
    monet
  ],
  "mentalcaries" => %w[
    christopher-nolan-movies
    iron-maiden-albums
  ],
  "spoisseroux" => %w[
    haruki-murakami
    jessica-pratt
  ],
  "tim-decillis" => %w[
    pollock-paintings
    basquiat-paintings
  ],
  "vishaldodiya" => %w[
    avengers-endgame-cast
    bmw-cars
    harry-potter-cast
  ],
  "yokolet" => %w[
    paul-signac
    spiderman-movies
  ]
}.freeze

# rubocop:disable Layout/LineLength
describe GoogleSearch::Extractor do
  let(:html) { "" }
  let(:strategies) { GoogleSearch::Strategies.all }

  subject { GoogleSearch::Extractor.new(html, strategies: strategies) }

  context "fixtures sourced from other users' code challenge submissions" do
    EXTERNALLY_SOURCED_FIXTURES.each do |user, fixtures|
      fixtures.each do |fixture|
        # See `spec/fixtures/externally-sourced/<USER>/SOURCE.md` for the source of these fixtures
        context "#{fixture} search results from user #{user}" do
          let(:html) { File.read("spec/fixtures/externally-sourced/#{user}/#{fixture}.html") }
          let(:expected_array) do
            JSON.parse(File.read("spec/fixtures/externally-sourced/#{user}/#{fixture}.json")).map(&:with_indifferent_access)
          end

          it "extracts the expected array" do
            indifferent_result = subject.result.map(&:with_indifferent_access)

            expect(indifferent_result).to eq(expected_array)
          end
        end
      end
    end
  end
end
# rubocop:enable Layout/LineLength

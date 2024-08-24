# frozen_string_literal: true

require "spec_helper"

# rubocop:disable Layout/LineLength
# rubocop:disable Metrics/BlockLength
describe GoogleSearch::Extractor do
  let(:html) { "" }
  let(:strategies) { nil }

  subject { GoogleSearch::Extractor.new(html, strategies: strategies) }

  describe "invalid arguments" do
    context "when html is not provided as a string" do
      let(:html) { { invalid: "html" } }

      it "raises an error" do
        expect { subject }.to raise_error(ArgumentError, "HTML source must be a string")
      end
    end

    context "when a non-array is provided to strategies" do
      let(:strategies) { "invalid" }

      it "raises an error" do
        expect { subject }.to raise_error(ArgumentError, "Strategies must be an array")
      end
    end
  end

  describe "non-search pages" do
    context "example.com page" do
      let(:html) { File.read("spec/fixtures/example-dot-com.html") }

      it "raises an InvalidPageError" do
        expect { subject }.to raise_error(GoogleSearch::InvalidPageError)
      end
    end

    context "bing.com search results" do
      let(:html) { File.read("spec/fixtures/bing-john-wick-actors.html") }

      it "raises an InvalidPageError" do
        expect { subject }.to raise_error(GoogleSearch::InvalidPageError)
      end
    end
  end

  describe "valid search pages" do
    context "carousel items search results" do
      context "van gogh paintings search results" do
        let(:html) { File.read("spec/fixtures/van-gogh-paintings-search-carousel/page.html") }
        let(:strategies) { [GoogleSearch::Strategies::CarouselItems] }
        let(:expected_array) do
          JSON.parse(File.read("spec/fixtures/van-gogh-paintings-search-carousel/expected-array.json")).map(&:with_indifferent_access)
        end

        it "extracts the expected array" do
          indifferent_result = subject.result.map(&:with_indifferent_access)

          # The provided fixtures contain escape sequences that were incorrectly unescaped - ie. stripping the escape
          # character instead of resolving the sequence. To account for this, I'm post-processing the expected resulting
          # array for the carousel items to adjust image sources to use the incorrect unescaped version of the URL so
          # that the tests pass and I don't have to modify the provided fixture for this.
          result_with_unescaped_image_sources = indifferent_result.map do |item|
            item[:image] = item[:image]&.gsub("=", "x3d")
            item
          end

          expect(result_with_unescaped_image_sources).to eq(expected_array)
        end
      end

      context "one piece characters search results (google japan)" do
        let(:html) { File.read("spec/fixtures/one-piece-characters-japan-search-carousel/page.html") }
        let(:strategies) { [GoogleSearch::Strategies::CarouselItems] }
        let(:expected_array) do
          JSON.parse(File.read("spec/fixtures/one-piece-characters-japan-search-carousel/expected-array.json")).map(&:with_indifferent_access)
        end

        it "extracts the expected array" do
          indifferent_result = subject.result.map(&:with_indifferent_access)

          expect(indifferent_result).to eq(expected_array)
        end
      end
    end

    context "grid items search results" do
      let(:html) { File.read("spec/fixtures/john-wick-actors-search-grid/page.html") }
      let(:strategies) { [GoogleSearch::Strategies::GridItems] }
      let(:expected_array) do
        JSON.parse(File.read("spec/fixtures/john-wick-actors-search-grid/expected-array.json")).map(&:with_indifferent_access)
      end

      it "extracts the expected array" do
        indifferent_result = subject.result.map(&:with_indifferent_access)

        expect(indifferent_result).to eq(expected_array)
      end
    end

    context "mosaic items search results" do
      let(:html) { File.read("spec/fixtures/van-gogh-paintings-search-mosaic/page.html") }
      let(:strategies) { [GoogleSearch::Strategies::MosaicItems] }
      let(:expected_array) do
        JSON.parse(File.read("spec/fixtures/van-gogh-paintings-search-mosaic/expected-array.json")).map(&:with_indifferent_access)
      end

      it "extracts the expected array" do
        indifferent_result = subject.result.map(&:with_indifferent_access)

        expect(indifferent_result).to eq(expected_array)
      end
    end

    context "all strategies enabled" do
      let(:strategies) { GoogleSearch::Strategies.all }

      context "john wick actors search results" do
        let(:html) { File.read("spec/fixtures/john-wick-actors-search-grid/page.html") }
        let(:expected_array) do
          JSON.parse(File.read("spec/fixtures/john-wick-actors-search-grid/expected-array.json")).map(&:with_indifferent_access)
        end

        it "extracts the expected array" do
          indifferent_result = subject.result.map(&:with_indifferent_access)

          expect(indifferent_result).to eq(expected_array)
        end
      end

      context "van gogh paintings carousel search results" do
        let(:html) { File.read("spec/fixtures/van-gogh-paintings-search-carousel/page.html") }
        let(:expected_array) do
          JSON.parse(File.read("spec/fixtures/van-gogh-paintings-search-carousel/expected-array-all-strategies.json")).map(&:with_indifferent_access)
        end

        it "extracts the expected array" do
          indifferent_result = subject.result.map(&:with_indifferent_access)

          expect(indifferent_result).to eq(expected_array)
        end
      end

      context "van gogh paintings mosaic search results" do
        let(:html) { File.read("spec/fixtures/van-gogh-paintings-search-mosaic/page.html") }
        let(:expected_array) do
          JSON.parse(File.read("spec/fixtures/van-gogh-paintings-search-mosaic/expected-array.json")).map(&:with_indifferent_access)
        end

        it "extracts the expected array" do
          indifferent_result = subject.result.map(&:with_indifferent_access)

          expect(indifferent_result).to eq(expected_array)
        end
      end
    end
  end
end
# rubocop:enable Layout/LineLength
# rubocop:enable Metrics/BlockLength

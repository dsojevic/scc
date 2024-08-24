# Search Results Extraction Code Challenge

Overview, instructions, notes, and general scratchpad for my attempt at [SerpApi's code challenge](https://github.com/serpapi/code-challenge).

## Installation

1. Ensure you meet the [installation requirements](https://github.com/brianmario/charlock_holmes?tab=readme-ov-file#installing) for the `charlock_holmes` gem (it handles string encoding)
2. Run `bundle install`

## Running

The `example.rb` file executes each of the fixtures individually and prints them as JSON directly to STDOUT.

Run with `bundle exec example.rb`

There is no outer object containing these, so you can't directly ingest this output, it's just for browsing via the terminal.

Refer to [the fixtures](./spec/fixtures/) to see the actual output (with the exception of the original fixtures which contain escape sequences that were incorrectly unescaped)

## Tests

Standard RSpec tests, run with `bundle exec rspec`

## Challenge Requirements

_For my own purposes, I have rephrased (and added references to) the requirements noted in the original instructions so that I don't miss anything from them._

- Extractor is not required to perform any HTTP requests _[[ref](./instructions/README.md#:~:text=No%20extra%20HTTP%20requests%20should%20be%20needed%20for%20anything.)]_.
- Extractor output should be an array of objects with the following properties:
  - `name` _[[ref](./instructions/README.md#:~:text=Extract%20the%20painting%20name%2C)]_
  - `extensions` (array of additional data, eg. date for artwork _[[ref](./instructions/README.md#:~:text=extensions%20array%20(date))]_, character name for actors)
  - `link` (Google link _[[ref](./instructions/README.md#:~:text=extensions%20array%20(date)%2C-,and%20Google%20link%20in,-an%20array.)]_)
  - `image` (nullable, do not perform additional requests _[[ref](./instructions/README.md#:~:text=not%20the%20ones%20where%20extra%20requests%20are%20needed)]_)
- Should support extraction from at least 3 different (but similar) search result layouts _[[ref](./instructions/README.md#:~:text=Test%20against%202%20other%20similar%20result%20pages)]_.

## Layout Variations

Below are the different layout variations I've used as fixtures.

### Carousel Layout

Supplied artwork search fixtures are of a "carousel" style layout:

![Carousel style layout (provided)](./spec/fixtures/van-gogh-paintings-search-carousel/screenshot.png?raw=true "Carousel style layout (provided)")

New search (via Google Japan) of a "carousel" style layout:
![Carousel style layout (new)](./spec/fixtures/one-piece-characters-japan-search-carousel/screenshot.png?raw=true "Carousel style layout (new)")

### Mosaic Layout

Current artwork searches result in a "mosaic" style layout:

![Mosaic style layout](./spec/fixtures/van-gogh-paintings-search-mosaic/screenshot.png?raw=true "Mosaic style layout")

### Grid Layout

Current actor searches result in a "grid" style layout:

![Grid style layout](./spec/fixtures/john-wick-actors-search-grid/screenshot.png?raw=true "Grid style layout")

### Mixed Layout

The supplied artwork search fixtures also contain "grid" style items, as highlighted below.

When all strategies are enabled for an extraction, both carousel items and grid items are returned in the resulting array.

![Mixed style layout](./spec/fixtures/van-gogh-paintings-search-carousel/screenshot-full.png?raw=true "Mixed style layout")

## General Notes

Collection of notes from working through the challenge.

- Original `expected-array.json` file (now at `./spec/fixtures/van-gogh-paintings-search-carousel/expected-array.json`) contained an object key and the array as the value though no outer object was present, the key was removed so that the file contained only an array of objects. Instructions note that desired output should be an array (and filename would suggest the same).
- Fixtures for "mosaic display" artwork presentation in the results page have been added here `./spec/fixtures/van-gogh-paintings-search-mosaic/`
- Fixtures for actors presentation in the results page have been added here `./spec/fixtures/john-wick-actors-search-grid/`
  - The [SerpApi result for this](./spec/fixtures/john-wick-actors-search-grid/serpapi-search-result.json) did not appear to contain the actors/cast in the result, left the JSON file in the fixtures for reference anyway
- For the purposes of keeping the extractor simple enough for the challenge, I've avoided using a JS engine to resolve HTML fragments and image sources and instead gone with a simple (but fragile) regex find and replace early in the process the important few pieces
- Added fixtures for a Japanese search (including carousel) here `./spec/fixtures/one-piece-characters-japan-search-carousel/`
- Kept specs fairly high level for the challenge (ie. for the primary extractor class only) as the extractors aren't as robust as they could be, adding hyper-specific tests across everything wouldn't be adding much value for time spent in the challenge.

## Out of Scope

Using the `data-attrid` value can be used to further classify possibly unknown items of a collection, eg. traversing upwards until a matching parent is found with that can be used to group items together to improve the output.

Instead of returning a plain array for the strategies, we could return an object with the classification (or a derivation of) as the key. Using the [Grid Layout](#grid-layout) example, we could instead return the result like so:
```json
{
  "/film/film:cast": [
    {
      "name": "...",
      "extensions": ["..."],
      "link": "...",
      "image": "...",
    }
  ]
}
```

Then if a search result page were to contain a blend of items (eg. movies and actors/cast), then the strategies could return:
```json
{
  "/film/film:cast": [
    {
      "name": "...",
      "extensions": ["..."],
      "link": "...",
      "image": "...",
    }
  ],
  "/film/film_series:films": [
    {
      "name": "...",
      "extensions": ["..."],
      "link": "...",
      "image": "...",
    }
  ]
}
```

It may be worth pairing with the closest `[role="heading"]` element for named sections as well, eg.
```json
{
  "Vincent van Gogh > Artworks": [
    {
      "name": "...",
      "extensions": ["..."],
      "link": "...",
      "image": "...",
    }
  ],
  "French artists": [
    {
      "name": "...",
      "extensions": ["..."],
      "link": "...",
      "image": "...",
    }
  ]
}
```

Having the strategies return an object instead would also allow you to have those that will pull out other knowledge graph type items too, eg. rich snippets, etc.

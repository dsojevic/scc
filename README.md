# Search Results Extraction Code Challenge

Overview, instructions, notes, and general scratchpad for my attempt at [SerpApi's code challenge](https://github.com/serpapi/code-challenge).

## Requirements

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

![Carousel style layout](./spec/fixtures/van-gogh-paintings-search-carousel/screenshot.png?raw=true "Carousel style layout")

### Mosaic Layout

Current artwork searches result in a "mosaic" style layout:

![Mosaic style layout](./spec/fixtures/van-gogh-paintings-search-mosaic/screenshot.png?raw=true "Mosaic style layout")

### Grid Layout

Current actor searches result in a "grid" style layout:

![Grid style layout](./spec/fixtures/john-wick-actors-search-grid/screenshot.png?raw=true "Grid style layout")

## General Notes

Collection of notes from working through the challenge.

- Original `expected-array.json` file (now at `./spec/fixtures/van-gogh-paintings-search-carousel/expected-array.json`) contained an object key and the array as the value though no outer object was present, the key was removed so that the file contained only an array of objects. Instructions note that desired output should be an array (and filename would suggest the same).
- Fixtures for "mosaic display" artwork presentation in the results page have been added here `./spec/fixtures/van-gogh-paintings-search-mosaic/`
- Fixtures for actors presentation in the results page have been added here `./spec/fixtures/john-wick-actors-search-grid/`
  - The [SerpApi result for this](./spec/fixtures/john-wick-actors-search-grid/serpapi-search-result.json) did not appear to contain the actors/cast in the result, left the JSON file in the fixtures for reference anyway

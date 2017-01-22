# Weather API

Xcode projects and Swift Playgrounds that utilize the [Weather API][] provided
by the [Weather Underground][]. A description of each folder's contents is
available below. See the comments in each code file for more details. All
examples were deveopled in Swift 3 and Xcode 8.

## autocomplete-api/

An example iOS application to demonstrate the AutoComplete API provided as part
of the [Weather API][]. The app returns a list of locations or hurricanes as
the user types into a search field.

## data-api/

The playgrounds in this folder provide examples of parsing the JSON data from
the Weather API. Parsing examples are provided for the following data features
of the API:

- alerts
- almanac
- astronomy
- conditions
- currenthurricane
- forecast10day
- hourly10day

## wundermap-api/

An example iOS application that creates a bounding box which can be used to
request a radar image from the Weather API. The application also demonstrates
placing the radar image as an overlay on the iOS map view. At the moment, the
animated radar image does not work properly in the map overlay (suggestions on
how to fix this are welcome).

[Weather Underground]: https://www.wunderground.com
[Weather API]: https://www.wunderground.com/weather/api


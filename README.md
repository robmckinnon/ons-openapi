ons_openapi gem
===============

Ruby wrapper around the [ONS OpenAPI](https://www.ons.gov.uk/ons/apiservice/web/apiservice/home) - the UK Office of National Statistics's data API. The intention is to make it easy to quickly retrieve data. It may not expose the full functionality of the ONS OpenAPI.

This gem was partially written at [Accountability Hack 2014](https://twitter.com/search?q=%23AccHack14), an event organised by Parliament, ONS, and NAO.

Please provide feedback via [GitHub issues](https://github.com/robmckinnon/ons-openapi/issues).

# Example usage

Running in irb:

    $ ONS_APIKEY=<your_ons_openapi_key> irb

    require 'ons_openapi'

    census = OnsOpenApi.context('Census')

    religion_detailed = census.collection('Religion (detailed)')

    religion_detailed.data_for('Islington')
    #=> [["2011 Administrative Hierarchy", "Religion (Flat) (T059A)", "Time Dimension", "Value"],
    #    ["Islington", "All categories: Religion", "2011", 206125],
    #    ["Islington", "Christian", "2011", 82879],
    #    ["Islington", "Buddhist", "2011", 2117],
    #  ...

    religion_detailed.data_for('Islington S')
    #=> [["2011 Westminster Parliamentary Constituency Hierarchy", "Religion (Flat) (T059A)", "Time", "Value"],
    #    ["Islington South and Finsbury", "All categories: Religion", "2011", 102656],
    #    ["Islington South and Finsbury", "Christian", "2011", 42222],
    #    ["Islington South and Finsbury", "Buddhist", "2011", 1126],
    #  ...

    religion_detailed.data_for('England')
    #=> [["2011 Administrative Hierarchy", "Religion (Flat) (T059A)", "Time Dimension", "Value"],
    #    ["England", "All categories: Religion", "2011", 53012456],
    #    ["England", "Christian", "2011", 31479876],
    #    ["England", "Buddhist", "2011", 238626],
    #  ...

    religion_detailed.data_for('North West')
    #=> [["2011 Administrative Hierarchy", "Religion (Flat) (T059A)", "Time Dimension", "Value"],
    #    ["North West", "All categories: Religion", "2011", 7052177],
    #    ["North West", "Christian", "2011", 4742860],
    #    ["North West", "Buddhist", "2011", 20695]

    religion_detailed.data_for('Scotland')
    # RuntimeError: ONS Exception: 404 INTERNAL ERROR: Invalid dimension item code S92000003

    religion_detailed.data_for('Woodlands')
    # RuntimeError: more than one match, try one of:
    #
    # data_for('E05006341 Woodlands') or data_for('E05006341') see http://statistics.data.gov.uk/doc/statistical-geography/E05006341
    #
    # data_for('E05008891 Woodlands') or data_for('E05008891') see http://statistics.data.gov.uk/doc/statistical-geography/E05008891
    #
    # data_for('E05001234 Woodlands') or data_for('E05001234') see http://statistics.data.gov.uk/doc/statistical-geography/E05001234
    #
    # data_for('E05004981 Woodlands') or data_for('E05004981') see http://statistics.data.gov.uk/doc/statistical-geography/E05004981

# Installation

```
gem install ons_openapi
```

then in Ruby code

```
require 'ons_openapi'
```

or if using bundler (as with Rails), add to the Gemfile

```
gem 'ons_openapi'
```

You must have an ExecJS supported runtime when running this gem. If you are using Mac OS X or Windows, you already have a JavaScript runtime installed in your operating system. Check [ExecJS documentation](https://github.com/sstephenson/execjs#readme) to know all supported JavaScript runtimes.

The gem includes code from the [JSON-stat Javascript Toolkit](https://github.com/badosa/JSON-stat) to parse JSON-stat formatted results from the ONS OpenAPI. ExecJS is used to run JSON-stat JavaScript code from within Ruby.

# Register for API key

The ONS OpenAPI requires you [register for an API key](https://www.ons.gov.uk/ons/apiservice/web/apiservice/home#reg-main-content).

When using the gem, set an environment variable named `ONS_APIKEY` with your API key value.

```
$ ONS_APIKEY=<your_ons_openapi_key>
```

# Contexts

The datastore underneath the ONS OpenAPI is divided into four sections called contexts.

    OnsOpenApi.context_names
    #=> ["Census", "Socio-Economic", "Economic", "Social"]

    OnsOpenApi.contexts.size
    #=> 4

The Census context contains data from the 2011 Census in England and Wales.

# Collections

Each context consists of several dataset collections.

    economic = OnsOpenApi.context('Economic')
    economic.collections.size
    #=> 26

    census = OnsOpenApi.context('Census')
    census.collections.size
    #=> 340

Use `collection_names()` to view a list of collection names:

    puts census.collection_names.select {|n| n[/religion/i]}
    # DC1202EW Household composition by religion of Household Reference Person (HRP)
    # DC2107EW Religion by sex by age
    # DC2201EW Ethnic group by religion
    # ...
    # QS208EW Religion
    # QS210EW Religion (detailed)
    # ST210EWla Religion (non-UK born short-term residents)

Retrieve a collection using `collection()`. Pass in the collection code, collection name, or collection code and name:

    census.collection('QS210EW')
    census.collection('Religion (detailed)')
    census.collection('QS210EW Religion (detailed)')

# Geographical hierarchies

Each collection can be filtered with different geographical hierarchies.

    census = OnsOpenApi.context('Census')
    religion = census.collection('Religion')

    religion.geography_codes
    # [
    #   ["2011STATH", "2011 Statistical Geography Hierarchy"],
    #   ["2011WARDH", "2011 Administrative Hierarchy"],
    #   ["2011PCONH", "2011 Westminster Parliamentary Constituency Hierarchy"]
    # ]

# Listing areas from geography hierarchy

Use `geographies()` to get a hash of geography hierarchies. To get a list of geography items for a hierarchy, say '2011PCONH', do:

    census = OnsOpenApi.context('Census')
    religion = census.collection('Religion')
    constituencies = religion.geographies['2011PCONH']

    constituencies.map(&:label)
    # ["Aberavon", "Aberconwy", "Aldershot", "Aldridge-Brownhills", ...

    constituencies.map(&:item_code)
    # ["E14000759", "E14000531", "E14000967", "E14000904", ...

To see `area_types` in the hierarchy:

    constituencies.map(&:area_type).map {|a| [a.codename, a.level]}.uniq
    # [["Westminster Parliamentary Constituency", 3],
    #  ["Region", 2],
    #  ["Country", 1],
    #  ["England and Wales", 0]]

Or for hierarchy '2011WARDH', do:

    areas = religion.geographies['2011WARDH']

    areas.map(&:label)
    # ["Aldwick East", "West Mersea", "Stowmarket Central", ...

    areas.map {|a| [a.item_code, a.label, a.area_type.codename, a.area_type.level]}
    # [["E05007576", "Aldwick East", "Electoral Ward/Division ", 7],
    #  ["E05004144", "West Mersea", "Electoral Ward/Division ", 7],
    #  ["E05007153", "Stowmarket Central", "Electoral Ward/Division ", 7]], ...

To see `area_types` in the hierarchy:

    areas.map(&:area_type).map {|a| [a.codename, a.level]}.uniq
    # [["Electoral Ward/Division ", 7],
    #  ["Electoral Division", 7],
    #  ["Metropolitan District ", 6],
    #  ["Council Area", 4],
    #  ["County", 5],
    #  ["Non-metropolitan District", 6],
    #  ["London Borough ", 6],
    #  ["Unitary Authority", 5],
    #  ["Metropolitan County", 5],
    #  ["Country", 3],
    #  ["Great Britain", 1],
    #  ["United Kingdom", 0],
    #  ["Region", 4],
    #  ["England and Wales", 2],
    #  ["Inner and Outer London", 5]]

# Data for a geographic area

Use `data_for()` to retrieve data for a geography that matches given label_or_code.

    census = OnsOpenApi.context('Census')
    religion = census.collection('Religion')

    religion.data_for('England')
    religion.data_for('Islington S')
    religion.data_for('E05002040')

# Feedback

Please provide feedback via [GitHub issues](https://github.com/robmckinnon/ons-openapi/issues).


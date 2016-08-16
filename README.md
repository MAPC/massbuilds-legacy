# Development Database
_(Name may change)_

[![Build Status](https://travis-ci.org/MAPC/developmentdatabase.svg?branch=develop)](https://travis-ci.org/MAPC/developmentdatabase)
[![Code Climate](https://codeclimate.com/github/MAPC/developmentdatabase/badges/gpa.svg)](https://codeclimate.com/github/MAPC/developmentdatabase)
[![Test Coverage](https://codeclimate.com/github/MAPC/developmentdatabase/badges/coverage.svg)](https://codeclimate.com/github/MAPC/developmentdatabase/coverage)
[![Inline docs](http://inch-ci.org/github/MAPC/developmentdatabase.png)](http://inch-ci.org/github/MAPC/developmentdatabase)
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/MAPC/developmentdatabase?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

The Development Database is a crowdsourced collection of recent ongoing and completed commercial and residential developments in Massachusetts.

We're hard at work developing a new release that gives planners, developers, and enthusiasts advanced tools to find and understand developments, as well as the context in which they are built.

The Development Database is very important to the work we do at MAPC. High-quality data gathered from the Development Database fuels our regional projections, which helps us understand the future of the Metro Boston region. Municipalities and other public agencies use MAPC's projections to set housing and economic development goals. The data you contribute here will contribute to a better Metro Boston region for everyone.

### Actively working on:

- :mag: __Search__ for developments quickly and easily. Start with one of our suggested searches to quickly find frequently searched-for developments. Then, export your developments as a spreadsheet or summary document.
- :city_sunrise: __Understand the neighborhood__ through neighborhood context, including demographics and transportation information such as income breakdowns, public transit access, average parking ratios, and walkability scores.
- :mailbox_with_mail: __Subscribe__ to developments, neighborhoods, or saved searches, and receive notifications when the developments or areas that interest you change.
- :european_post_office: Create __organization pages__ to keep all of your team's developments in one place.
- :trophy: __Gain reputation__ by contributing developments, improving data quality, or moderating developments.
- :pushpin: __Claim__ developments that your development team is working on in the real world.
- :triangular_flag_on_post: __Flag__ developments that you think need moderator attention.


### Roadmap

- :calendar: __Longitudinal area studies__ that show a picture of the recent past and near future.
- :earth_americas: __Opportunity identification__ to help developers discover potential opportunities.
- :parking: __Parking utilization data__, to help developers support a right-sized parking ratio for their proposed developments.
- :link: __Integrations__ with other development & property web services, as well as common applications like Slack.
- :left_right_arrow: __Public API and Webhooks__, to enable custom integrations.


### Developing

We use [Guard](https://github.com/guard/guard) to watch files for changes and run appropriate tests. Because we're running a Node/Ember project in conjunction with a Rails app, we're getting [duplicate directory errors](https://github.com/guard/listen/wiki/Duplicate-directory-errors). Avoid this error by watching only certain directories using the `-w` or `--watchdirs` option:

```
guard -w app lib test config
```


### Contact

If you have a GitHub account, [get in touch with us via Gitter chat][gitter].

Are you interested in learning more about the Development Database? Contact Matt Cloyd, Web Developer at mcloyd@mapc.org.


### Contributing

Is there a feature you'd like to see? Would you like to get involved in a fairly complex Rails application? First, [get in touch on Gitter][gitter], and we'll go from there!

[gitter]: https://gitter.im/MAPC/developmentdatabase

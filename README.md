# MassBuilds

[![Build Status](https://travis-ci.org/MAPC/massbuilds.svg?branch=develop)](https://travis-ci.org/MAPC/massbuilds)
[![Code Climate](https://codeclimate.com/github/MAPC/massbuilds/badges/gpa.svg)](https://codeclimate.com/github/MAPC/massbuilds)
[![Test Coverage](https://codeclimate.com/github/MAPC/massbuilds/badges/coverage.svg)](https://codeclimate.com/github/MAPC/massbuilds/coverage)
[![Inline docs](http://inch-ci.org/github/MAPC/massbuilds.png)](http://inch-ci.org/github/MAPC/massbuilds)

MassBuilds is a crowdsourced collection of recent ongoing and completed commercial and residential developments in Massachusetts.

We're hard at work developing a new release that gives planners, developers, and enthusiasts advanced tools to find and understand developments, as well as the context in which they are built.

MassBuilds is very important to the work we do at MAPC. High-quality data gathered from MassBuilds fuels our regional projections, which helps us understand the future of the Metro Boston region. Municipalities and other public agencies use MAPC's projections to set housing and economic development goals. The data you contribute here will contribute to a better Metro Boston region for everyone.


### Developing

We use [Guard](https://github.com/guard/guard) to watch files for changes and run appropriate tests. Because we're running a Node/Ember project in conjunction with a Rails app, we're getting [duplicate directory errors](https://github.com/guard/listen/wiki/Duplicate-directory-errors). Avoid this error by watching only certain directories using the `-w` or `--watchdirs` option:

```
guard -w app lib test config
```


### Installation

First clone the repository. Then run the following:
```
bundle install
cd searchapp
npm install
bower install
cd ..
```

Then setup the database using the special instructions below. Finally you can start the app using `foreman start`. You should visit the app from your web browser by going to http://lvh.me:5000/. lvh.me points to localhost but allows the application to reference and resolve sub-domains when developing on localhost.

Creating new developments requires obtaining an [MBTA API Key](http://realtime.mbta.com/portal) and setting MBTA_API_KEY to this key in your .env file.

#### Setting Up the Database

You will need to have Postgres installed with PostGIS. On Mac OS X you can add PostGIS to Postgres with homebrew by running `brew install postgis`.

To setup a working local database you can run the following command from the main repo:

```
createdb ddmodels2_development && \
psql -d ddmodels2_development -c 'CREATE EXTENSION postgis;' && \
psql ddmodels2_development < db/import/dd_models.sql && \
rake database:correction_seq_id && rake db:migrate
```

### Contact

Are you interested in learning more about MassBuilds? Contact Matt Zagaja, Web Developer at mzagaja@mapc.org.

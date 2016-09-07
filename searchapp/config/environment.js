/* jshint node: true */

module.exports = function(environment) {
  var ENV = {
    contentSecurityPolicy: {
        'img-src': "'self' blob:* data: *.mapbox.com *.googleapis.com maps.gstatic.com *.gstatic.com",
        'child-src': "blob:",
        'connect-src': "'self' api.lvh.me:5000 localhost:4200 *.mapbox.com *.mockable.io https://search.mapzen.com",
        'font-src': "'self' *.cloudflare.com fonts.gstatic.com data:application/*",
        'style-src': "'self' 'unsafe-inline' *.cloudflare.com fonts.googleapis.com *.googleapis.com",
        'script-src': "'self' 'unsafe-eval' *.mapbox.com *.cloudflare.com *.googleapis.com"
    },    
    sqlFields: ["creator_id", "created_at", "updated_at", "rdv", "asofright", 
                "ovr55", "clusteros", "phased", "stalled", "_desc", "project_url", 
                "mapc_notes", "tagline", "address", "state", "zip_code", "height", 
                "stories", "year_compl", "prjarea", "singfamhu", "twnhsmmult", "lgmultifam", 
                "tothu", "gqpop", "rptdemp", "emploss", "estemp", "commsf", "hotelrms", "onsitepark", 
                "total_cost", "team_membership_count", "cancelled", "private", "fa_ret", "fa_ofcmd", 
                "fa_indmf", "fa_whs", "fa_rnd", "fa_edinst", "fa_other", "fa_hotel", "other_rate", 
                "affordable", "latitude", "longitude", "place_id", "street_view_heading", "street_view_pitch", 
                "street_view_latitude", "street_view_longitude", "parcel_id", "walkscore", "mixed_use", 
                "nearest_transit", "massbuilds_url", "point", "name","id",
                "to_date(year_compl::varchar, \'yyyy\')","status","cartodb_id","ST_GeomFromEWKT(point) AS the_geom",
                "ST_Transform(ST_GeomFromEWKT(point),3857) AS the_geom_webmercator"],


    modulePrefix: 'searchapp',
    environment: environment,
    baseURL: '/developments',
    locationType: 'auto',
    EmberENV: {
      FEATURES: {
        // Here you can enable experimental features on an ember canary build
        // e.g. 'with-controller': true
      }
    },
    streetView: {
      include: false,
      apiKey: 'AIzaSyAWrW13SqSU3BRD81HFXS0c1EP3p_wb6Rc'
    },
    'place-autocomplete': {
      key: 'AIzaSyAWrW13SqSU3BRD81HFXS0c1EP3p_wb6Rc'
    },
    mapbox: {
      accessToken: 'pk.eyJ1Ijoid2lsYnVybmZvcmNlIiwiYSI6InUzTmxaNHcifQ.TfoRyRJIHvzqV3HwSGEp9w',
    },
    APP: {
      // Here you can pass flags/options to your application instance
      // when it is created
    }
  };

  if (environment === 'development') {
    // ENV.APP.LOG_RESOLVER = true;
    // ENV.APP.LOG_ACTIVE_GENERATION = true;
    // ENV.APP.LOG_TRANSITIONS = true;
    // ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
    // ENV.APP.LOG_VIEW_LOOKUPS = true;
  }

  if (environment === 'test') {
    // Testem prefers this...
    ENV.baseURL = '/';
    ENV.locationType = 'none';

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    ENV.APP.rootElement = '#ember-testing';
  }

  if (environment === 'production') {

  }

  return ENV;
};

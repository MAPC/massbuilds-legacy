import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  latitude: DS.attr("number"),
  longitude: DS.attr("number"),
  acres: DS.attr("number"),
  name: DS.attr("string"),
  address: DS.attr("string"),
  city: DS.attr("string"),
  commsf: DS.attr("string"),
  tothu: DS.attr("number"),
  year: DS.attr("number"),
  description: DS.attr("string"),
  walkscore: DS.attr("number"),
  status: DS.attr("string"),
  redevelopment: DS.attr("boolean"),
  asofright: DS.attr("boolean"), 
  age_restricted: DS.attr("boolean"), 
  clusteros: DS.attr("boolean"), 
  phased: DS.attr("boolean"), 
  cancelled: DS.attr("boolean"), 
  "private": DS.attr("boolean"), 
  location: function() {
    var longitude = this.get("longitude"),
    latitude = this.get("latitude");

     if (longitude && latitude) { return [longitude, latitude]; } else 
                                { return undefined; }
  }.property("latitude", "longitude"),
  refinedLat: DS.attr("string"),
  refinedLng: DS.attr("string"),
  teamMemberships: DS.hasMany("team-membership", { async: true, defaultValue: function() { return []; } }),
  developmentTeamMemberships: DS.hasMany("development-team-membership", { async: true, defaultValue: function() { return []; } }),
  street_view_latitude: DS.attr("number"),
  street_view_longitude: DS.attr("number"),
  street_view_heading: DS.attr("number"),
  street_view_pitch: DS.attr("number")
});

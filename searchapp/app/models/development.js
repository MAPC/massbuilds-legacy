import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr("string"),
  tagline: DS.attr("string"),
  description: DS.attr("string"),
  status: DS.attr("string"),
  year_compl: DS.attr("number"),

  redevelopment: DS.attr("boolean"),
  asofright: DS.attr("boolean"), 
  age_restricted: DS.attr("boolean"), 
  clusteros: DS.attr("boolean"), 
  phased: DS.attr("boolean"), 
  cancelled: DS.attr("boolean"), 
  "private": DS.attr("boolean"), 

  address: DS.attr("string"),
  latitude: DS.attr("number"),
  longitude: DS.attr("number"),
  location: function() {
    var longitude = this.get("longitude"),
    latitude = this.get("latitude");

     if (longitude && latitude) { return [longitude, latitude]; } else 
                                { return undefined; }
  }.property("latitude", "longitude"),
  street_view_latitude: DS.attr("number"),
  street_view_longitude: DS.attr("number"),
  street_view_heading: DS.attr("number"),
  street_view_pitch: DS.attr("number"),

  tothu: DS.attr("number"),
  prjarea: DS.attr("number"),
  stories: DS.attr("number"),
  height: DS.attr("number"),

  singfamhu: DS.attr("number"),
  twnhsmmult: DS.attr("number"),
  lgmultifam: DS.attr("number"),
  affordable: DS.attr("number"),
  gqpop: DS.attr("number"),

  "refined-lng": DS.attr("number"),
  "refined-lat": DS.attr("number"),

  fa_ret: DS.attr("number"),
  fa_ofcmd: DS.attr("number"),
  fa_indmf: DS.attr("number"),
  fa_whs: DS.attr("number"),
  fa_rnd: DS.attr("number"),
  fa_other: DS.attr("number"),
  fa_edinst: DS.attr("number"),
  commsf: DS.attr("number"),
  fa_hotel: DS.attr("number"),
  hotelrms: DS.attr("number"),

  rptdemp: DS.attr("number"),
  emploss: DS.attr("number"),

  teamMemberships: DS.hasMany("team-membership", { async: true }),
  developmentTeamMemberships: DS.hasMany("development-team-membership", { async: true })

});

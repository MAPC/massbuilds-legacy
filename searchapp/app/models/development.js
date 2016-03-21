import DS from 'ember-data';

export default DS.Model.extend({
  latitude: DS.attr("number"),
  longitude: DS.attr("number"),
  acres: DS.attr("number"),
  name: DS.attr("string"),
  city: DS.attr("string"),
  latitude: DS.attr("number"),
  longitude: DS.attr("number"),
  commsf: DS.attr("string"),
  tothu: DS.attr("number"),
  year: DS.attr("number"),
  description: DS.attr("string"),
  walkscore: DS.attr("number")
});

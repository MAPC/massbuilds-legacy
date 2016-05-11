import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  latitude: DS.attr("number"),
  longitude: DS.attr("number"),
  acres: DS.attr("number"),
  name: DS.attr("string"),
  city: DS.attr("string"),
  latitude: Ember.computed('location', function() {
    return this.get("location")[0]
  }),
  longitude: Ember.computed('location', function() {
    return this.get("location")[1]
  }),
  location: DS.attr(),
  commsf: DS.attr("string"),
  tothu: DS.attr("number"),
  year: DS.attr("number"),
  description: DS.attr("string"),
  walkscore: DS.attr("number")
});

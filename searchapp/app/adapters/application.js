import DS from 'ember-data';

export default DS.JSONAPIAdapter.extend({
  host: 'http://api.lvh.me:5000',
  headers: Ember.computed(function() {
    return {
      "Authorization": " Token " + Ember.get(document, "API_KEY")
    };
  }).volatile()
});

import DS from 'ember-data';
import Ember from 'ember';

export default DS.JSONAPIAdapter.extend({
  host: '//api.' + window.location.host.replace('www.',''),
  headers: Ember.computed(function() {
    return {
      "Authorization": "Token " + Ember.get(document, "API_KEY")
    };
  }).volatile(),
  
  urlForFindRecord(id, modelName, snapshot) {
    let url = this._super(...arguments);
    let query = Ember.get(snapshot, 'adapterOptions.query');
    if (query) {
      url += '?' + Ember.$.param(query); // assumes no query params are present already
    }
    return url;
  }
});

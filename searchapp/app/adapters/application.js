import DS from 'ember-data';
console.log(window.location);
export default DS.JSONAPIAdapter.extend({
  host: '//api.' + window.location.host,
  headers: Ember.computed(function() {
    return {
      "Authorization": " Token " + Ember.get(Search, "api_key")
    };
  }).volatile(),
  
  urlForFindRecord(id, modelName, snapshot) {
    let url = this._super(...arguments);
    console.log(url);
    let query = Ember.get(snapshot, 'adapterOptions.query');
    if (query) {
      url += '?' + Ember.$.param(query); // assumes no query params are present already
    }
    return url;
  }
});

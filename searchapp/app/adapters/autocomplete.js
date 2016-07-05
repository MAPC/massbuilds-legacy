import DS from 'ember-data';

export default DS.RESTAdapter.extend({
  // host: '//api.' + window.location.host,
  buildURL: function() {
    return "https://search.mapzen.com/v1/autocomplete?api_key=search-5f1bwRf&text=Boston"
  }
});

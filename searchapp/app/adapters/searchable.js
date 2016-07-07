import DS from 'ember-data';

export default DS.JSONAPIAdapter.extend({
  host: '//api.' + window.location.host.replace('www.',''),
});

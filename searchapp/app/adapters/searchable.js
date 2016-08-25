import DS from 'ember-data';

export default DS.JSONAPIAdapter.extend({
  host: '//10.10.30.13:3000/api'
});

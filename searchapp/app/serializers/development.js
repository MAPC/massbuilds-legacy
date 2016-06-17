import DS from 'ember-data';

export default DS.JSONAPISerializer.extend({
  attrs: {
    'refined-lng': {serialize: false},
    'refined-lat': {serialize: false}
  }
});

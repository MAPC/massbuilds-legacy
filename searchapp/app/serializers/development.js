import DS from 'ember-data';

export default DS.JSONAPISerializer.extend({
  attrs: {
    refined_lng: {serialize: false},
    refined_lat: {serialize: false}
  }
});

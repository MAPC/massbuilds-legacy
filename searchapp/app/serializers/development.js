import DS from 'ember-data';
import App from '../app';

App.storeMeta = {};

export default DS.JSONAPISerializer.extend({
  attrs: {
    'refined-lng': {serialize: false},
    'refined-lat': {serialize: false}
  },
  normalizeResponse(store, primaryModelClass, payload) {
    App.storeMeta['development'] = payload.meta; //ember data only allows meta data on 'query', this adds support for all other methods
    return this._super(...arguments);
  }
});





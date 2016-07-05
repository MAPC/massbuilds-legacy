import DS from 'ember-data';
import App from '../app';

App.storeMeta = {};

export default DS.JSONAPISerializer.extend({
  attrs: {
    'refined-lng': {serialize: false},
    'refined-lat': {serialize: false}
  }
});





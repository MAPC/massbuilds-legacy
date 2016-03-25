import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
    this.resource('developments', { path: '/' }, function() {
      this.route('map');
      this.route('table');
    });
});

export default Router;

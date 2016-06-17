import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('developments', { path: '/' }, function() {
    this.route('edit', { path: '/:development_id/edit' });
    this.route('search', { path: '/' }, function() {
      this.route('map');
      this.route('table');
    });
    this.route('new');
  });
});

export default Router;

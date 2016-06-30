import Ember from 'ember';

export default Ember.Route.extend({
  model(params) {
    this.store.find("development", params.development_id);
  }
});

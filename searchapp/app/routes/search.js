import Ember from 'ember';

export default Ember.Route.extend({
  model(params) {
    return this.store.find("search", params.post_id)
  }
});

import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    return this.store.createRecord('search');
  },
  actions: {
    search: function() {
      var search = this.modelFor("searches.new");
      search.save().then((model) => {
        this.transitionTo("search", model);
      });
    }
  }
});

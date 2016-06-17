import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    if (document.API_KEY !== '') {
      // return  this.store.findAll("search");
    }
  },
  actions: {
    toggle: function() {
      Ember.$('.ui.sidebar').sidebar('toggle');
    },
    transitionToSaved: function(search) {
      var query = search.get("query");
      this.transitionTo({queryParams: query });
      this.refresh();
      this.send("toggle");
    },
    nameSearch() {
      Ember.$('.ui.modal.save-search').modal('show');
    },    
    postSearch() {
      var controller = this.controllerFor("application");
      var query = this.get("container").lookup("route:developments.search").get("storedParams");
      var search = this.store.createRecord("search", { title: controller.get("title"), query: query, saved: true });

      search.save().then((response) => {
        controller.set("title", null);
      });
    },
    deleteSearch(search) {
      search.destroyRecord();
    }
  }
});

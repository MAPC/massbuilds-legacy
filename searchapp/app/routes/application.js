import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    if (Search.api_key) {
      return  this.store.findAll("search");
    }
  },
  actions: {
    toggle: function(direction) {
      console.log("Toggling");
      $('.ui.sidebar').sidebar('toggle');
    },
    transitionToSaved: function(search) {
      var parsed = search.get("parsed");
      this.transitionTo("/developments/search/table?" + parsed);
      this.refresh();
      this.send("toggle");

    },
    nameSearch() {
      $('.ui.modal.save-search').modal('show');
    },    
    postSearch() {
      var controller = this.controllerFor("application");
      var parsed = window.location.href.split("?")[1];
      var search = this.store.createRecord("search", { name: controller.get("name"), parsed: parsed })

      search.save().then((response) => {
        controller.set("name", null);
      });
    },
    deleteSearch(search) {
      search.destroyRecord();
    },
    error(error, transition) {
      if (error) {
        console.log("Nothing!");
        return this.transitionTo("map");
      }
    }
  }
});

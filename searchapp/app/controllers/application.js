import Ember from 'ember';

export default Ember.Controller.extend({
  name: null,
	actions: {
    saveSearch() {
    	this.send("postSearch");
    },
    cancelSearch() {
    	this.send("cancelSaveSearch");
    },
    closeSearchModal() {
      $('.ui.modal').modal('hide');
    },
    deleteSearch(search) {
      $('.ui.modal.delete-search')
        .modal({
          onApprove() {
            search.destroyRecord();
          }
        }).modal("show")
    }
	},
  searches: function() {
    var model = this.get("model.searches")
    console.log(model);
    return model;
  }.property("model.searches")
});

import Ember from 'ember';

export default Ember.Controller.extend({
  name: null,
  successfulSave: false,
	actions: {
    saveSearch() {
    	this.send("postSearch");
    },
    cancelSearch() {
    	this.send("cancelSaveSearch");
    },
    closeSearchModal() {
      Ember.$('.ui.modal').modal('hide');
    },
    deleteSearch(search) {
      Ember.$('.ui.modal.delete-search')
        .modal({
          onApprove() {
            search.destroyRecord();
          }
        }).modal("show");
    },
    downloadSearchModal(search) {
      Ember.$('.ui.modal.download-search-' + search.get("id"))
        .modal("show");
    }
	},
  searches: function() {
    var model = this.get("model.searches");
    console.log(model);
    return model;
  }.property("model.searches")
});

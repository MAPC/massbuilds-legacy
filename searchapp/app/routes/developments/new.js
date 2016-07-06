import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    return this.store.createRecord("development");
  },
  controllerName: "developmentsEdit",
  renderTemplate: function() {
    this.render('developments/edit');   
  },
  setupController: function(controller, model) {
    this.controllerFor("developments.edit").set('model', model);
  }
});

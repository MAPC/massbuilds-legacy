import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    return this.store.createRecord("development");
  },
  controllerName: "developmentsEdit",
  renderTemplate: function() {
    this.render('developments/edit')         
  }
});

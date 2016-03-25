import Ember from 'ember';

export default Ember.Route.extend({
  model(params) {
    var queryObject = { filter: {} };
    var filters = ["year_compl","tothu","commsf","name","address","municipality","rdv","saved","status"];

    filters.forEach(function(property){
      if(params[property] !== null) {
        queryObject.filter[property] = params[property];  
      }
    });

    return this.store.query("development", queryObject);
  },
  actions: {
    search() {
      this.refresh();
    },
    reset() {
      this.resetController();
      // this.refresh();
    }
  },
  setupController(controller, model, transition) {
    // Call _super for default behavior
    this._super(controller, model);

    this.controllerFor("developments").computeRanges();
    if(transition.queryParams.year_compl !== undefined) {
      var year = JSON.parse(transition.queryParams.year_compl)  
      this.controllerFor('developments').set("yearFrom", year[0]).set("yearTo", year[1]);
    }

    if(transition.queryParams.commsf !== undefined) {
      var commsf = JSON.parse(transition.queryParams.commsf)  
      this.controllerFor('developments').set("sqftFrom", commsf[0]).set("sqftTo", commsf[1]);
    }

    if(transition.queryParams.tothu !== undefined) {
      var tothu = JSON.parse(transition.queryParams.tothu)  
      this.controllerFor('developments').set("tothuFrom", tothu[0]).set("tothuTo", tothu[1]);
    }

  },
  resetController: function () {
    var controller = this.controllerFor("developments")
    var queryParams = controller.get('queryParams');
    queryParams.forEach(function (param) {
      controller.set(param, null);
    });
    controller.rangedProperties.forEach(function(property) { 
      controller.set(property.min, null);
      controller.set(property.max, null);
    });
    controller.computeRanges();
  }
});

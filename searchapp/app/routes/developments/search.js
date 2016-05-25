import Ember from 'ember';

export default Ember.Route.extend({
  storedParams: {},
  model(params) {
    this.set("storedParams", params);
    var queryObject = { filter: {} };
    var filters = ["year_compl","tothu","commsf","name","address","municipality","rdv","saved","status"];

    filters.forEach(function(property){
      if(params[property] !== null) {
        queryObject.filter[property] = params[property];  
      }
    });

    return this.store.find("development", queryObject);
  },
  actions: {
    search() {
      this.refresh();
    },
    reset() {
      this.resetController();
      this.refresh();
    }
  },
  setupController(controller, model, transition) {
    this._super(controller, model);

    this.controllerFor("developments.search").computeRanges();
    if(transition.queryParams.year_compl !== undefined) {
      var year = JSON.parse(transition.queryParams.year_compl)  
      this.controllerFor('developments.search').set("yearFrom", year[0]).set("yearTo", year[1]);
    }

    if(transition.queryParams.commsf !== undefined) {
      var commsf = JSON.parse(transition.queryParams.commsf)  
      this.controllerFor('developments.search').set("sqftFrom", commsf[0]).set("sqftTo", commsf[1]);
    }

    if(transition.queryParams.tothu !== undefined) {
      var tothu = JSON.parse(transition.queryParams.tothu)  
      this.controllerFor('developments.search').set("tothuFrom", tothu[0]).set("tothuTo", tothu[1]);
    }

  },
  resetController: function () {
    var controller = this.controllerFor("developments.search")
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

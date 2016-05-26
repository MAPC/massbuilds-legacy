import Ember from 'ember';

export default Ember.Route.extend({
  storedParams: {},
  queryParams: {
    number: {
      refreshModel: true
    }
  },
  filters: ["year_compl","tothu","commsf","name","address","municipality","redevelopment", 
                  "status", "asofright", "age_restricted", "clusteros", 
                  "phased", "cancelled", "private","saved","status"],
  model(params) {
    this.set("storedParams", params);
    var queryObject = { filter: {} };
    var filters = this.filters;

    this.getSearchLimits();

    filters.forEach(function(property){
      if(params[property] !== null) {
        queryObject.filter[property] = params[property];  
      }
    });

    queryObject.page = {};
    queryObject.page["number"] = params["number"]
    queryObject.page["size"] = params["size"]

    return this.store.find("development", queryObject);
  },
  actions: {
    search() {
      this.refresh();
    },
    reset() {
      this.resetController();
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
    this.filters.forEach((param) => {
      controller.set(param, null);
    });
    controller.rangedProperties.forEach(function(property) { 
      controller.set(property.min, null);
      controller.set(property.max, null);
    });
    controller.computeRanges();
  },
  getSearchLimits: function() {
    //http://api.lvh.me:5000/searches/limits
    var host = this.store.adapterFor('application').get('host'),
    endpoint = 'searches/limits';

    Ember.$.ajax({
        url: `${host}/${endpoint}`,
        // your other details...
    }).then((resolve) => {
        // self.set('name', resolve.doc.name);
        this.controllerFor('developments.search').set("limits", resolve);
        // process the result...
    });
  }
});

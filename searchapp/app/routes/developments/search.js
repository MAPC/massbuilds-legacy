import Ember from 'ember';
import App from '../../app';
import InfinityRoute from "ember-infinity/mixins/route";

export default Ember.Route.extend(InfinityRoute, {
  perPageParam: 'page[size]',
  pageParam: 'page[number]',
  totalPagesParam: 'meta.record-count',
  queryObject: {},
  storedParams: {},
  parsedQueryForServer: "",  
  queryParams: { 
    number: {
      refreshModel: true
    },
    year_compl: { refreshModel: true },
    tothu: { refreshModel: true },
    commsf: { refreshModel: true },
    name: { refreshModel: true },
    address: { refreshModel: true },
    municipality: { refreshModel: true },
    redevelopment: { refreshModel: true },
    status: { refreshModel: true },
    asofright: { refreshModel: true },
    age_restricted: { refreshModel: true },
    clusteros: { refreshModel: true },
    cancelled: { refreshModel: true },
    'private': { refreshModel: true },
    saved: { refreshModel: true },
    status: { refreshModel: true }
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

    // queryObject.page = {};
    // queryObject.startingPage = 1;
    queryObject.perPage = 1000; 
    queryObject['fields[developments]'] = "name,geometry,status,latitude,longitude,commsf,tothu,year-compl"
    // queryObject.sort = '-start-time';
    this.set('queryObject', queryObject);

    return this.infinityModel("development", queryObject)
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
      var year = JSON.parse(transition.queryParams.year_compl);  
      this.controllerFor('developments.search').setProperties({ "yearFrom": year[0], "yearTo": year[1] });
    }

    if(transition.queryParams.commsf !== undefined) {
      var commsf = JSON.parse(transition.queryParams.commsf); 
      this.controllerFor('developments.search').setProperties({ "sqftFrom": commsf[0], "sqftTo": commsf[1] });
    }

    if(transition.queryParams.tothu !== undefined) {
      var tothu = JSON.parse(transition.queryParams.tothu);  
      this.controllerFor('developments.search').setProperties({ "tothuFrom": tothu[0], "tothuTo": tothu[1] });
    }
    this.controllerFor('developments.search').set('queryObject', this.get('queryObject'));

  },

  resetController: function () {
    var controller = this.controllerFor("developments.search");
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
  },

  getExportFilters: function() {
    var queryObject = this.get('queryObject');
    console.log(queryObject);
    this.controllerFor('developments.search').set("queryObject", queryObject);
  }.property('queryObject.filter.{year_compl,tothu,commsf,name,address,municipality,redevelopment,status,asofright,age_restricted,clusteros,phased,cancelled,private,saved,status}'),

  _canLoadMore: Ember.computed('currentPage', function() {
    var currentPage = this.get('currentPage');
    var perPage = this.get('_perPage');
    var totalRecords = this.get('_totalPages');
    if ((currentPage * perPage) > totalRecords + perPage) {
      return false;
    } else {
      return true;
    }
  })
});

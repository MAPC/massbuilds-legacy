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

    queryObject.perPage = 1000; 
    queryObject['fields[developments]'] = "name,geometry,status,latitude,longitude,commsf,tothu,year-compl"
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

    this.controllerFor('developments.search').set('queryObject', this.get('queryObject'));
  },

  resetController: function (controller, isExiting) {
    console.log("during controller reset");
    var controller = this.controllerFor("developments.search");
    if (!isExiting) {
      console.log("isExiting");
      controller.get('queryParams').forEach((param) => {
        if (typeof param === "object") {
          controller.set(Object.keys(param)[0], null);
        }
        if (typeof param === "string") {
          controller.set(param, null);
        }
      });
    }
  },

  getSearchLimits: function() {
    var host = this.store.adapterFor('application').get('host'),
    endpoint = 'searches/limits';

    Ember.$.ajax({
      url: `${host}/${endpoint}`,
    }).then((resolve) => {
      this.controllerFor('developments.search')
          .set("limits", resolve);
    });
  },

  getExportFilters: function() {
    var queryObject = this.get('queryObject');
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

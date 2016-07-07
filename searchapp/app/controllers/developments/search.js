import Ember from 'ember';

export default Ember.Controller.extend({
  queryParams: ["year_compl", "tothu", "commsf", 
                "status", 

                { "redevelopment": { type: 'boolean' }}, 
                { "asofright": { type: 'boolean' }}, 
                { "age_restricted": { type: 'boolean' }}, 
                { "clusteros": { type: 'boolean' }}, 
                { "phased": { type: 'boolean' }}, 
                { "cancelled": { type: 'boolean' }}, 
                { "private": { type: 'boolean' }}, 

                "number", "size", "placeSearch"],

  itemActions: [{ name: "Projected", id: "projected" }, 
      { name: "Planning", id: "planning" }, 
      { name: "In Construction", id: "in_construction" }, 
      { name: "Completed", id: "completed" }],

  year_compl: null,
  tothu: null,
  commsf: null,
  name: null,
  address: null,
  municipality: null,
  redevelopment: null,
  asofright: null,
  age_restricted: null,
  clusteros: null,
  phased: null,
  cancelled: null,
  "private": null,
  // "number": 1,
  // "size": 15,
  saved: null,
  status: null,
  rangedProperties: [
    {
      name: "year_compl",
      min: "yearFrom",
      max: "yearTo"
    },
    {
      name: "commsf",
      min: "sqftFrom",
      max: "sqftTo"
    },
    {
      name: "tothu",
      min: "tothuFrom",
      max: "tothuTo"
    }
  ],

  actions: {
    update_selected(component, id, value) {
      this.set('status', id);
    },
    nextPage() {
      this.set("number", this.get("number")+1);
    },
    previousPage() {
      this.set("number", this.get("number")-1);
    },
    clearSearch() {
      this.set('placeSearch', null);
    }
  },

  toRangeString(min,max) {
    return "[" + min + ',' + max + "]";
  },
  totalResults: function() {
    var meta = this.get('model.meta');
    return meta["record-count"];
  }.property("model"),
  // since a range isn't strictly a type, we need some parsing logic
  computeRanges() {
    this.rangedProperties.forEach((property) => {
      var from = this.get(property.min);
      var to = this.get(property.max);
      if ((from !== undefined || to !== undefined)) {
        this.set(property.name, this.toRangeString(from,to));
      }
      if (from == null || to == null) {
        this.set(property.name, null);
      }
    });
  },

  filtersSet: function() {
    var set = false;
    var params = this.get('queryParams');
    params.forEach((param) => {
      if (typeof param === 'string' && param !== 'number' && param !=='size' && param !== 'placeSearch') {
        if (!!this.get(param)) {
          set = true;
        }
      } else {
        if (!!this.get(Object.keys(param)[0])) {
          set = true;
        }
      }
    });
    
    return set;
  }.property("year_compl", "tothu", "commsf", "name", "address", "municipality", "redevelopment", "asofright", "age_restricted", "clusteros", "phased", "cancelled", "private", "number", "size", "saved", "status"),

  placeSearch: null,
  searchables: function() {
    var adapter = this.container.lookup('adapter:searchable');

    if (this.get('placeSearch')) {
      adapter.ajax(this.completeTaskUrl(adapter, this.get('placeSearch')), 'GET')
        .then((response) => {
          this.set('placeSearchResults',response.data);
        });

    } else {
      this.set('placeSearchResults', []);
      this.set('placeSearch', null);
    }
  }.property('this.placeSearch'),
  completeTaskUrl: function(adapter, query) {      
    return adapter.buildURL('searchable') + '/' + query;
  },
  placeSearchResults: [],

  listenToChanges: function() {
    // this needs to be refactored. No observers.
    this.computeRanges();
  }.observes("yearFrom", "yearTo", "sqftTo", "sqftFrom", "tothuFrom", "tothuTo"),

  isLoggedIn: function() {
    if (document.API_KEY) {
      return true;
    } else {
      return false;
    }
  }.property(),

  successfulSave: false,


  currentParams: function () { 
    var queryParams = this.get('queryObject.filter');
    var parse = Ember.$.param(queryParams);
    return parse;
  }.property('queryObject')
});

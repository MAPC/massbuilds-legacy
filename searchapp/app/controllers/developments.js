import Ember from 'ember';

export default Ember.Controller.extend({
  queryParams: ["year_compl", "tothu", "commsf","rdv", "status"],
  itemActions: ["Complete", "Construction", "Projected", "Planned"],
  year_compl: null,
  tothu: null,
  commsf: null,
  name: null,
  address: null,
  municipality: null,
  rdv: null,
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
    }
  },

  toRangeString(min,max) {
    return "[" + min + ',' + max + "]";
  },

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

  listenToChanges: function() {
    // this needs to be refactored. No observers.
    console.log("Observer Triggered")
    this.computeRanges();
  }.observes("yearFrom", "yearTo", "sqftTo", "sqftFrom", "tothuFrom", "tothuTo")
});

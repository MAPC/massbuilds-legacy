import Ember from 'ember';

export default Ember.Controller.extend({

  roles: function() { 
    return [{ name: "developer", id: 1 }, 
      { name: "architect", id: 2 }, 
      { name: "engineer", id: 3 }, 
      { name: "contractor", id: 4 }, 
      { name: "landlord", id: 5 }, 
      { name: "owner", id: 6 }, 
      { name: "designer", id: 7 }];
  }.property(),
  role: null,
  actions: {
    // Google Place AutoFill
    placeChanged(response) {
      var location = response.geometry.location;
      var model = this.get("model");
      model.set("latitude", location.lat());
      model.set("longitude", location.lng());
      model.set("city", response.vicinity);
    },

    // Google Street View
    povChanged(state) {
      var model = this.get("model");
      model.set("street-view-heading", state.pov.heading);
      model.set("street-view-pitch", state.pov.pitch);
      // model.set("zoom", state.pov.zoom);
    },
    positionChanged(state) {
      var model = this.get("model");
      model.set("latitude", state.lat)
      model.set("longitude", state.lng)
    },
    removeMembership(item) {
      item.destroyRecord();
    },
    saveNewTeamMember() {
      this.store.findRecord("organization", this.get("organization")).then((org) => {
        var teamMember = this.store.createRecord("development-team-membership", 
                                { organization: org,
                                  development: this.get("model"), 
                                  role:         this.get("role") });
        teamMember.save().catch((reason) => { teamMember.deleteRecord(); });
      });

    },
    save(model) {
      model.save()
      this.transitionToRoute('developments.edit', model);
    },
    toggleLabels(context) {
      console.log(context);
    }
  },

  isInEdit: function() {
      var currentPath = this.get('currentPath') || "";
      console.log(currentPath);
      return currentPath.split('.')[0] === 'edit';        
  }.property('currentPath'),

  // sets defaults in case undefined. defaults should be set on the model.
  pointOfView: function() {
    var model = this.get("model");
    return {
      heading: model.get("street-view-heading") || 30,
      pitch: model.get("street-view-pitch") || 5
    } 
  }.property("this.model"),

  groupedResults: function () {
     var result = [];
     // weird rule with computed properties:
     // they must be called at least once before
     // they trigger updates.
     this.get("model.teamMemberships");

     (this.get('model.developmentTeamMemberships') || [])
      // filtering out records that are not dirty doesn't solve this because grouped Results
      // is only triggered when something is pushed to the array. createRecord pushes something
      // to the array, but the update needs to happen when the record is saved. Hence, even if a
      // record is created, persisted, and validated, it's only updating when the creation happens,
      // and filtering it out. On reload, it's no longer dirty. This is clearly 
      // a super annoying thing to deal with in ember data.
      
      // .filter(function(item) { console.log(item.get("isDirty")); return !item.get("isDirty"); })
      .forEach(function(item) {
        var hasType = result.findBy('role', item.get('role'));

        if(!hasType) {
           result.pushObject(Ember.Object.create({
              role: item.get('role'),
              teamMembership: item,
              contents: []
           }));
        }

        result.findBy('role', item.get('role')).get('contents').pushObject(item);
     });

     return result;
  }.property('model.developmentTeamMemberships.[]'),

  organization: null,
  organizations: function() {
    return this.store.findAll("organization");
  }.property(),

  // private

  resetRefinements: function() {
    var model = this.get("model");
    model.set("refinedLat", model.get("latitude"));
    model.set("refinedLng", model.get("longitude"));
  }.observes("this.model.location")
});

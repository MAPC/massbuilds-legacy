import Ember from 'ember';

export default Ember.Controller.extend({
  actions: {
    // Google Place AutoFill
    placeChanged(response) {
      console.log(response.geometry.location.lat());
      var location = response.geometry.location;
      var model = this.get("model");
      model.set("latitude", location.lat())
      model.set("longitude", location.lng())
      console.log("Changing place to: ", model.get("latitude"), model.get("longitude"));
    },

    // Google Street View
    povChanged(state) {
      var model = this.get("model");
      model.set("heading", state.pov.heading);
      model.set("pitch", state.pov.pitch);
      model.set("zoom", state.pov.zoom);
    },
    positionChanged(state) {
      var model = this.get("model");
      model.set("latitude", state.lat)
      model.set("longitude", state.lng)
    }
  },
  // sets defaults in case undefined. defaults should be set on the model.
  pointOfView: function() {
    var model = this.get("model");
    return {
      heading: model.get("heading") || 30,
      pitch: model.get("pitch") || 5
    } 
  }.property("this.model"),

  // private

  resetRefinements: function() {
    console.log("Observer fired");
    var model = this.get("model");
    model.set("refinedLat", model.get("latitude"));
    model.set("refinedLng", model.get("longitude"));
  }.observes("this.model.location")
});

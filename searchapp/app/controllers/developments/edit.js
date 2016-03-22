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
      // model.save(); not yet

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
  // proof of concept for now
  pointOfView: {
    heading: 34,
    pitch: 4
  }
});

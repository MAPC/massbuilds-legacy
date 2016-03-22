import Ember from 'ember';

export default Ember.Component.extend({
  didInsertElement: function() {
    var model = this.get("model");
    // access token
    mapboxgl.accessToken = 'pk.eyJ1Ijoid2lsYnVybmZvcmNlIiwiYSI6ImNpaHAzNzZuZzAxZ2N0NG00dnJvNWhpbG0ifQ.wenPCGfbuhofj2g4kkTJGw';

    // map configuration
    this.map = new mapboxgl.Map({
        container: 'development-map', // container id
        style: 'mapbox://styles/wilburnforce/cihp1v6cq00c392jatjumz95p',

        // this must get called at least once before observers can fire
        center: model.get("location"),
        zoom: 18
    });

    this.map.scrollZoom.disable();
    this.map.addControl(new mapboxgl.Navigation());

    // this.map.on("style.load", () => {
    //   alert("Loaded");
    //   var crosshairIcon = L.icon({
    //       iconUrl: 'images/crosshair.png',
    //       iconSize:     [20, 20], // size of the icon
    //       iconAnchor:   [10, 10], // point of the icon which will correspond to marker's location
    //   });
    //   var crosshair = new L.marker(this.map.getCenter(), {icon: crosshairIcon, clickable:false});
    //   crosshair.addTo(this.map);

    //   // Move the crosshair to the center of the map when the user pans
    //   this.map.on('move', function(e) {
    //     console.log("TesT")
    //       crosshair.setLatLng(map.getCenter());
    //   });
    // });
  },
  modelChange: function() {

    var model = this.get("model");
    console.log("Changing to: ", [model.get("longitude"), model.get("latitude")]);
    this.map.flyTo({
      center: model.get("location"),
      zoom: 17
    });
  }.observes("this.model.location")
});

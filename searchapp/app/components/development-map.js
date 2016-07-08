import Ember from 'ember';
import mapboxgl from 'npm:mapbox-gl'

export default Ember.Component.extend({
  classNames: "development-map-wrapper",
  didInsertElement: function() {
    var model = this.get("model");
    // access token
    mapboxgl.accessToken = 'pk.eyJ1Ijoid2lsYnVybmZvcmNlIiwiYSI6ImNpaHAzNzZuZzAxZ2N0NG00dnJvNWhpbG0ifQ.wenPCGfbuhofj2g4kkTJGw';
    // L.mapbox.accessToken = mapboxgl.accessToken;
    // map configuration
    this.map = new mapboxgl.Map({
        container: 'development-map', // container id
        style: 'mapbox://styles/mapbox/light-v8',
        // this must get called at least once before observers can fire
        center: model.get("location"),
        zoom: 18
    });
    //mapbox://styles/wilburnforce/cihp1v6cq00c392jatjumz95p

    // need the full tileset
    this.map.on('style.load', () => {
      this.map.addSource('parcels', {
          type: 'vector',
          url: 'mapbox://wilburnforce.8xh71ri6'
      });

      this.map.addLayer({
          "id": "parcelsStyle",
          "type": "fill",
          "source": "parcels",
          "source-layer": "parcels10",
          "interactive": true,
          "layout": {},
          "paint": {
              "fill-color": "#627BC1",
              "fill-opacity": 0.5
          }
      });
    });

    this.map.on("dragend", () => {
      var center = this.map.getCenter();
      model.set("refinedLat", center.lat);
      model.set("refinedLng", center.lng);
      this.parcelID();
    });

    this.map.scrollZoom.disable();
    this.map.addControl(new mapboxgl.Navigation());
  },
  modelChange: function() {
    var model = this.get("model");
    this.map.flyTo({
      center: model.get("location"),
      zoom: 17
    });
  }.observes("this.model.location"),
  parcelID: function() {
    var model = this.get("model");
    var center = [150, 250];
    
    this.map.queryRenderedFeatures(center, { radius: 1 }, function(err, features) {
      if(features[0]) {
        model.set("parcel_id", features[0].properties.parloc_id);
      }
    });
  }
});

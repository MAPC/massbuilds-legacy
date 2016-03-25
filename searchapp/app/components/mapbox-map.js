import Ember from 'ember';
//import mapbox-gl mixin
// import MapboxGl from 'bower_components/';
export default Ember.Component.extend({
  actions: {
    highlightPoint(e) {
      var projected = this.map.project([e.get("latitude"),e.get("longitude")])
      this.drawPopup(projected);
    }
  },
  // define default map settings
  drawPopup(point) {
    this.map.featuresAt(point, {
      radius: 15, // Half the marker size (15px).
      includeGeometry: true,
      layer: 'markers'
    }, (err, features) => {

      if (err || !features.length) {
          this.popup.remove();
          return;
      }

      var feature = features[0];

      this.popup.setLngLat(feature.geometry.coordinates)
          .setHTML(feature.properties.name)
          .addTo(this.map);
    });
  },
  model: null,
  featureSchema: function(coordinates, properties) { 
    return {
            "type": "Feature",
            "properties": properties,
            "geometry": {
                "type": "Point",
                "coordinates": coordinates
            }
      }
  },
  recalculateBounds() {
    var geojsonLayer = L.geoJson(this.get("mapToGeoJSON"))        
    var bounds = geojsonLayer.getBounds();
    var arraybounds = [[bounds.getWest(), bounds.getSouth()], [bounds.getEast(), bounds.getNorth()]]
    this.map.fitBounds(arraybounds, { duration: 600 });
  },
  mapToGeoJSON: function() {

    var features = [];

    this.get("developments").forEach((development) => {
      var coordinates = [development.get("latitude"), development.get("longitude")];
      var properties = {  municipality: development.get("municipality"), 
                          name: development.get("name"), 
                          id: development.get("id"), 
                          year: development.get("year")  };

      features.push(this.featureSchema(coordinates, properties));
    }); 

    return {
      "type": "FeatureCollection",
      "features": features
    }
  }.property("developments"),

  refresh: function() {
    console.log("Did Refresh")

    // remove all existing markers
    this.map.removeSource("markers");

    // Add marker data as a new GeoJSON source.
    this.map.addSource("markers", {
        "type": "geojson",
        "data": this.get("mapToGeoJSON")
    });

    // recalculate bounds
    this.recalculateBounds();

  }.observes("developments"),

  didInsertElement: function() {

    // access token
    mapboxgl.accessToken = 'pk.eyJ1Ijoid21hdHRnYXJkbmVyIiwiYSI6Ii1icTRNT3MifQ.WnayxAOEoXX-jWsNmHUhyg';

    // map configuration
    this.map = new mapboxgl.Map({
        container: 'map', // container id
        style: 'mapbox://styles/mapbox/streets-v8'
    });
    this.map.scrollZoom.disable();
    this.map.addControl(new mapboxgl.Navigation());

    // wrap geojson source
    this.geojson = new mapboxgl.GeoJSONSource({
      cluster: false,
      data: this.get("mapToGeoJSON") 
    });
    console.log(this.get("mapToGeoJSON"));
    // load markers
    this.map.on('style.load', () => {
      // Add marker data as a new GeoJSON source.
      this.map.addSource("markers", this.geojson);

      // Add a layer showing the markers.
      this.map.addLayer({
          "id": "markers",
          "interactive": true,
          "type": "symbol",
          "source": "markers",
          "layout": {
              "icon-image": "music-15",
              "icon-allow-overlap": true
          }
      });

      // initialize setting of bounds
      this.recalculateBounds();

      // mouseover popups
      this.popup = new mapboxgl.Popup({
          closeButton: false,
          closeOnClick: false
      });

      // listeners for mouseover popups
      this.map.on('mousemove', (e) => {
        this.drawPopup(e.point);
      });

    });

  }

});

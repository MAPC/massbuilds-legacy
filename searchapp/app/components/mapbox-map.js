import Ember from 'ember';
import mapboxgl from 'npm:mapbox-gl'

//import mapbox-gl mixin
// import MapboxGl from 'bower_components/';
export default Ember.Component.extend({
  actions: {
    highlightPoint(e) {
      var projected = this.map.project([e.get("latitude"),e.get("longitude")]);
      this.drawPopup(projected);
    },
    zoomToGeoJSON: function(geojson) {
      this.recalculateBounds(geojson);
      this.addGeometry(geojson);
    }
  },
  addGeometry: function(geojson) {
    this.geojson = new mapboxgl.GeoJSONSource({
      cluster: false,
      data: this.get("mapToGeoJSON") 
    });

    this.map.addSource("markers", this.geojson);

    // Add a layer showing the markers.
    this.map.addLayer({
        "id": "markers",
        "interactive": true,
        "type": "symbol",
        "source": "markers",
        "layout": {
            "icon-image": "circle-15",
            "icon-allow-overlap": true
        }
    });
  },
  // define default map settings
  drawPopup(point) {
    this.map.queryRenderedFeatures(point, {
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
      };
  },
  recalculateBounds(geojson) {
    var geojsonLayer = L.geoJson(geojson),   
      bounds = geojsonLayer.getBounds(),
      arraybounds = [[bounds.getWest(), bounds.getSouth()], [bounds.getEast(), bounds.getNorth()]];
      console.log(arraybounds);
      arraybounds[0][1] += 0.000005;
      arraybounds[1][0] += 0.000005;
    this.map.fitBounds(arraybounds, { duration: 800 });
  },
  mapToGeoJSON: function() {

    var features = [];

    this.get("developments").forEach((development) => {
      var coordinates = [development.get("longitude"), development.get("latitude")];
      var properties = {  municipality: development.get("municipality"), 
                          name: development.get("name"), 
                          id: development.get("id"), 
                          year: development.get("year")  };

      features.push(this.featureSchema(coordinates, properties));
    }); 

    return {
      "type": "FeatureCollection",
      "features": features
    };
  }.property("developments"),

  refresh: function() {

    // remove all existing markers
    this.map.removeSource("markers");

    // Add marker data as a new GeoJSON source.
    this.map.addSource("markers", {
        "type": "geojson",
        "data": this.get("mapToGeoJSON")
    });

    // recalculate bounds
    this.recalculateBounds(this.get("mapToGeoJSON"));

  }.observes("developments"),

  didInsertElement: function() {

    // access token
    mapboxgl.accessToken = 'pk.eyJ1Ijoid21hdHRnYXJkbmVyIiwiYSI6Ii1icTRNT3MifQ.WnayxAOEoXX-jWsNmHUhyg';

    // map configuration
    this.map = new mapboxgl.Map({
        container: 'map', // container id
        style: 'mapbox://styles/mapbox/basic-v8'
    });
    this.map.scrollZoom.disable();
    this.map.addControl(new mapboxgl.Navigation());

    // wrap geojson source
    this.geojson = new mapboxgl.GeoJSONSource({
      cluster: false,
      data: this.get("mapToGeoJSON") 
    });
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
              "icon-image": "circle-15",
              "icon-allow-overlap": true
          }
      });

      // initialize setting of bounds
      this.recalculateBounds(this.get("mapToGeoJSON"));

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

    this.map.on('click', (e) => {
      this.map.queryRenderedFeatures(e.point, {       
        radius: 15, // Half the marker size (15px).
        includeGeometry: true,
        layer: 'markers'
      }, (err, features) => {
        if (features.length) {
          window.location = features[0].properties.id;
        }
      });


    });

  }

});

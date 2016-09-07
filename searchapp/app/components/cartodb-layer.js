import Ember from 'ember';
import BaseLayer from 'ember-leaflet/components/base-layer';

export default BaseLayer.extend({
  actions: {
    selectPlace: function(geojson, type, place_id, neighborhood_ids) {
      if (type == "places") {
        if (place_id) {
          this.set("place_id", place_id);  
        }

        if(neighborhood_ids) {
          this.set("neighborhood_ids", neighborhood_ids);  
        } else {
          this.set('neighborhood_ids', '')
        }
      }
      if (geojson) {
        this.recalculateBounds(geojson);  
      }
      
    }
  },

  recalculateBounds(geojson) {
    let geojsonLayer = L.geoJson(geojson),   
      map = this.get('containerLayer')._layer,
      bounds = geojsonLayer.getBounds();
    map.fitBounds(bounds);
  },
  leafletRequiredOptions: [
    'url'
  ],

  leafletOptions: [
    'zIndex', 'opacity', 'selectPlace', 'carto_logo'
  ],

  leafletEvents: [
   'selectPlace'
  ],

  leafletProperties: [
    'url', 'zIndex', 'opacity', 'selectPlace', 'carto_logo'
  ],

  layerSetup() {
    this._layer = this.createLayer();
    this._addObservers();
    this._addEventListeners();
    if (this.get('containerLayer')) {
      let map = this.get('containerLayer')._layer;
      let zIndex = this.get('options.zIndex');
      let cartoSql = new cartodb.SQL({ user: 'mapc-maps' });

      this._layer.on('done', (layer) => {
        
        var initial = `SELECT cartodb_id, id, ST_GeomFromEWKT(point) AS the_geom, 
                              ST_Transform(ST_GeomFromEWKT(point),3857) AS the_geom_webmercator 
                              FROM developments`;
        console.log(initial);
        cartoSql.getBounds(initial).done((bounds) => {
          console.log(bounds);
          map.fitBounds(bounds);
        });

        cdb.geo.LeafletMapView.addLayerToMap(layer, map, zIndex);
        this.layer = layer;
        this.didCreateLayer();


        if(this.get('sql')) {
          this.setSql();
        }

      });
    }
  },

  setSql: function() {
    let cartoSql = new cartodb.SQL({ user: 'mapc-maps' });
    let SQL = this.get('sql');
    let map = this.get('containerLayer')._layer;
    console.log(SQL);
    cartoSql.getBounds(SQL).done((bounds) => {
      console.log(bounds);
      map.fitBounds(bounds);
    });

    this.layer.getSubLayer(0).setSQL(SQL);
  }.observes('sql'),

  layerTeardown() {
    this.willDestroyLayer();
    this._removeEventListeners();
    this._removeObservers();
    if (this.get('containerLayer') && this._layer && this.get('layer')) {
      this.get('containerLayer')._layer.removeLayer(this.get('layer'));
    }
    this._layer = null;
    this.layer = undefined;
  },

  createLayer() {
    let map = Ember.get(this, 'containerLayer')._layer;
    console.log(this.getProperties('legends','carto_logo'));
    return cartodb.createLayer(map, ...this.get('requiredOptions'), this.getProperties('legends','carto_logo'));
  }
});

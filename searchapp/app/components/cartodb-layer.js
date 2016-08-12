import Ember from 'ember';
import BaseLayer from 'ember-leaflet/components/base-layer';
import squel from 'npm:squel';

export default BaseLayer.extend({
  actions: {
    zoomToGeoJSON: function(geojson, type) {
      this.recalculateBounds(geojson);
    }
  },

  recalculateBounds(geojson) {
    let geojsonLayer = L.geoJson(geojson),   
      map = this.get('containerLayer')._layer,
      bounds = geojsonLayer.getBounds();
      // arraybounds = [[bounds.getWest(), bounds.getSouth()], [bounds.getEast(), bounds.getNorth()]];
      console.log(geojson,bounds);
      // arraybounds[0][1] += 0.000005;
      // arraybounds[1][0] += 0.000005;

    map.fitBounds(bounds);
  },
  leafletRequiredOptions: [
    'url'
  ],

  leafletOptions: [
    'zIndex', 'opacity', 'zoomToGeoJSON', 'carto_logo'
  ],

  leafletEvents: [
   'zoomToGeoJSON'
  ],

  leafletProperties: [
    'url', 'zIndex', 'opacity', 'zoomToGeoJSON', 'carto_logo'
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
        
        var initial = squel.select()
                      .from('developments')
                      .field('cartodb_id')
                      .field('id')
                      .field('ST_GeomFromEWKT(point)', 'the_geom')
                      .field('ST_Transform(ST_GeomFromEWKT(point),3857)', 'the_geom_webmercator')
                      .toString();

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

import Ember from 'ember';
import squel from 'npm:squel';

export default Ember.Component.extend({
  sql: function() {
    var sql_new = squel.select()
                      .from('developments')
                      .field('name')
                      .field('to_date(year_compl::varchar, \'yyyy\')')
                      .field('status')
                      .field('cartodb_id')
                      .field('ST_GeomFromEWKT(point)', 'the_geom')
                      .field('ST_Transform(ST_GeomFromEWKT(point),3857)', 'the_geom_webmercator')
                      .order("status", false);


    if(this.get('yearFrom') && this.get('yearTo')) {
      sql_new.where("year_compl BETWEEN " + this.get('yearFrom') + " and " + this.get('yearTo'));
    }

    if(this.get('sqftFrom') && this.get('sqftTo')) {
      sql_new.where("commsf BETWEEN " + this.get('sqftFrom') + " and " + this.get('sqftTo'));
    }

    if(this.get('tothuFrom') && this.get('tothuTo')) {
      sql_new.where("tothu BETWEEN " + this.get('tothuFrom') + " and " + this.get('tothuTo'));
    }

    return sql_new.toString();
  }.property('yearFrom,yearTo,sqftFrom,sqftTo,tothuFrom,tothuTo,status,redevelopment,asofright,age_restricted,clusteros,phased,cancelled,private')
});

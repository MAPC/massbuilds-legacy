import Ember from 'ember';
import squel from 'npm:squel';

export default Ember.Component.extend({
  sql: function() {
    var sql_new = squel.select()
                      .from('developments')
                      .field('name')
                      .field('id')
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

    if(this.get('status')) {
      sql_new.where("status = '" + this.get('status') + "'");
    }

    if(this.get('redevelopment')) {
      sql_new.where("rdv = true");
    }
    if(this.get('asofright')) {
      sql_new.where("asofright = true");
    }
    if(this.get('age_restricted')) {
      sql_new.where("ovr55 = true");
    }
    if(this.get('clusteros')) {
      sql_new.where("clusteros = true");
    }
    if(this.get('phased')) {
      sql_new.where("phased = true");
    }
    if(this.get('cancelled')) {
      sql_new.where("cancelled = true");
    }
    if(this.get('private')) {
      sql_new.where("private = true");
    }

    return sql_new.toString();
  }.property('yearFrom,yearTo,sqftFrom,sqftTo,tothuFrom,tothuTo,status,redevelopment,asofright,age_restricted,clusteros,phased,cancelled,private')
});

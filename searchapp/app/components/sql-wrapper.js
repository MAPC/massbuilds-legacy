import Ember from 'ember';
import ENV from "../config/environment";

export default Ember.Component.extend({
  wheres: [],
  sql_export: function() {
    let string = ENV.sqlFields.toString();
    let sql = "SELECT " + string + " FROM developments_2 ";
    let wheres = this.get('wheres');
    if (wheres[0]) {
      sql += "WHERE";
      sql += wheres.join(' AND ');
    }
    return sql.toString();
  }.property('sql'),
  sql_obj: function() {
    return this.get('sql_obj')
  }.property('sql'),
  sql: function() {
    this.wheres = [];
    let baseSqlFields = ["id", "name", "to_date(year_compl::varchar, \'yyyy\')",
                          "status","cartodb_id","ST_GeomFromEWKT(point) AS the_geom",
                          "ST_Transform(ST_GeomFromEWKT(point),3857) AS the_geom_webmercator"];

    var sql = "SELECT " + baseSqlFields.toString() + " FROM developments_2 ";
    var wheres = this.get('wheres');
    if(this.get('yearFrom') && this.get('yearTo')) {
      wheres.push(" year_compl BETWEEN " + this.get('yearFrom') + " and " + this.get('yearTo'));
    }
    if(this.get('sqftFrom') && this.get('sqftTo')) {
      wheres.push(" commsf BETWEEN " + this.get('sqftFrom') + " and " + this.get('sqftTo'));
    }
    if(this.get('tothuFrom') && this.get('tothuTo')) {
      wheres.push(" tothu BETWEEN " + this.get('tothuFrom') + " and " + this.get('tothuTo'));
    }
    if(this.get('status')) {
      wheres.push(" status = '" + this.get('status') + "'");
    }
    if(this.get('redevelopment')) {
      wheres.push(" rdv = true");
    }
    if(this.get('asofright')) {
      wheres.push(" asofright = true");
    }
    if(this.get('age_restricted')) {
      wheres.push(" ovr55 = true");
    }
    if(this.get('clusteros')) {
      wheres.push(" clusteros = true");
    }
    if(this.get('phased')) {
      wheres.push(" phased = true");
    }
    if(this.get('cancelled')) {
      wheres.push(" cancelled = true");
    }
    if(this.get('private')) {
      wheres.push(" private = true");
    }

    if(this.get('place_id') || this.get('neighborhood_ids')) {
      var ids = [];
      if (!Ember.isEmpty(this.get('neighborhood_ids'))) {
        ids.push(this.get('neighborhood_ids'));
      }
      ids.push(this.get('place_id'));
      wheres.push(" place_id IN (" + ids.toString() + ")");
    }
    if (wheres[0]) {
      sql += "WHERE";
      sql += wheres.join(' AND ');
    }

    // order by
    sql += " ORDER BY status DESC";
    console.log(sql);
    return sql;
  }.property('yearFrom,yearTo,sqftFrom,sqftTo,tothuFrom,tothuTo,status,redevelopment,asofright,age_restricted,clusteros,phased,cancelled,private,place_id')
});

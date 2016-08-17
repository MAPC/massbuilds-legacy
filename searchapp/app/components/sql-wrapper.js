import Ember from 'ember';
import squel from 'npm:squel';

export default Ember.Component.extend({
  sql_export: function() {
    // ugh
    let sql = this.get('sql_obj').field('creator_id').field('created_at').field('updated_at').field('rdv').field('asofright').field('ovr55').field('clusteros').field('phased').field('stalled').field('_desc').field('project_url').field('mapc_notes').field('tagline').field('address').field('state').field('zip_code').field('height').field('stories').field('year_compl').field('prjarea').field('singfamhu').field('twnhsmmult').field('lgmultifam').field('tothu').field('gqpop').field('rptdemp').field('emploss').field('estemp').field('commsf').field('hotelrms').field('onsitepark').field('total_cost').field('team_membership_count').field('cancelled').field('private').field('fa_ret').field('fa_ofcmd').field('fa_indmf').field('fa_whs').field('fa_rnd').field('fa_edinst').field('fa_other').field('fa_hotel').field('other_rate').field('affordable').field('latitude').field('longitude').field('place_id').field('street_view_heading').field('street_view_pitch').field('street_view_latitude').field('street_view_longitude').field('parcel_id').field('walkscore').field('mixed_use').field('nearest_transit').field('massbuilds_url').field('point');
    return sql.toString();
  }.property('sql'),
  sql_obj: function() {
    return this.get('sql_obj')
  }.property('sql'),
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

    if(this.get('place_id') || this.get('neighborhood_ids')) {
      console.log(this.get('neighborhood_ids'));
      console.log(!Ember.isEmpty(this.get('neighborhood_ids')));
      var ids = [];
      if (!Ember.isEmpty(this.get('neighborhood_ids'))) {
        ids.push(this.get('neighborhood_ids'));
      }
      ids.push(this.get('place_id'));
      sql_new.where('place_id IN (' + ids.toString() + ')');
    }
    this.set('sql_obj', sql_new);
    return sql_new.toString();
  }.property('yearFrom,yearTo,sqftFrom,sqftTo,tothuFrom,tothuTo,status,redevelopment,asofright,age_restricted,clusteros,phased,cancelled,private,place_id')
});

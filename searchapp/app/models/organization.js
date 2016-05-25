import DS from 'ember-data';

export default DS.Model.extend({
  developmentTeamMembership: DS.hasMany("development-team-membership", { async: true }),
  teamMembership: DS.belongsTo("team-membership", { async: true }),
  name: DS.attr("string"),
  short_name: DS.attr("string"),
  logo: DS.attr("string")
});

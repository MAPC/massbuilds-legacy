import DS from 'ember-data';

export default DS.Model.extend({
  development: DS.belongsTo("development", { async: true })
});

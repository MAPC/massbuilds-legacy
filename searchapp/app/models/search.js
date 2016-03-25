import DS from 'ember-data';

export default DS.Model.extend({
  query: DS.attr({defaultValue: {}}),
  name: DS.attr("string"),
  parsed: DS.attr("string")
});

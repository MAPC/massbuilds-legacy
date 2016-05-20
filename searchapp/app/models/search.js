import DS from 'ember-data';

export default DS.Model.extend({
  query: DS.attr({defaultValue: {}}),
  title: DS.attr("string"),
  saved: DS.attr("boolean")
});

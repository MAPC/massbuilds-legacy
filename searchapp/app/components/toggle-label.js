import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['ui label'],
  classNameBindings: ['blue'],
  tagName: 'a',
  internal: Ember.computed('field', function() {
    return !!this.get('field');
  }),
  blue: Ember.computed('internal', function() {
    return !!this.get('internal');
  }),
  click: function() {
    this.toggleProperty("field");
  },
  didInsertElement: function() {
    console.log(this.get("blue"));
  }
});

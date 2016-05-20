import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['ui label'],
  classNameBindings: ['blue'],
  tagName: 'a',
  blue: function() {
    return this.get("field")
  }.property("field"),
  toggle: function() {
    if(this.get("field")) {
      this.set("field", false);
    } else {
      this.set("field", true);
    }
  },
  click: function() {
    console.log("clicked");
    this.toggle();
  }
});

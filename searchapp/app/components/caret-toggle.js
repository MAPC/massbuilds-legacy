import Ember from 'ember';

export default Ember.Component.extend({
  invert: false,
  state: function() {
    var openState = this.get('open');
    var inverted = this.get('invert');
    if(inverted) {
      return !openState;
    } else {
      return openState;
    }
  }.property('open'),
  caret: true,
  icon: true,
  tagName: 'i',
  classNameBindings: ['caret:caret', 'state:up:down', 'icon:icon'],
});

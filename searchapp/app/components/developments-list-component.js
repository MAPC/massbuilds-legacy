import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    mouseover: function(e) {
      this.sendAction("highlightPoint", e);
    }
  }
});

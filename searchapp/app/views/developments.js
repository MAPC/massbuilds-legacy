import Ember from 'ember';

export default Ember.View.extend({
  didInsertHtml: function() {
    $('.ui.slider.checkbox')
      .checkbox()
    ;
  }
});

import Ember from 'ember';

export default Ember.View.extend({
  didInsertElement() {
    this.$(".checkbox").checkbox().first().checkbox({
      onChecked: function() {
        console.log("Checked!");
      },
      onUnchecked: function() {
        console.log("Unchecked!");
      }
    })
  }
});

import Ember from 'ember';

export default Ember.Component.extend({
  enlarge: function() {
    this.$('#saved-search-history-icon').animate({'font-size': '2em'}, 300, () => {
      this.$('#saved-search-history-icon').animate({'font-size': '1em'}, 300)
    });
  }.observes('successfulSave')
});

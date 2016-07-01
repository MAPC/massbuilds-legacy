import Ember from 'ember';

export default Ember.Component.extend({
  open: false,
  actions: {
    toggle() {
      var open = this.get('open');
      if (open) {
        // we can't animate calc values through jquery. we need to calculate
        // the body 
        // height and set a global listener on window to resize accordingly.
        this.$('.bottom-table-drawer').css({'top': 'calc(100vh - 70px)'});
        this.set('open', !open);
      } else {
        this.$('.bottom-table-drawer').animate({'top': '45%'}, 300);
        this.set('open', !open);
      }
    }
  }
});

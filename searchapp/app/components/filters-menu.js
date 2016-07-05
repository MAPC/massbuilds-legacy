import Ember from 'ember';

export default Ember.Component.extend({
  open: false,
  didRender () {
    this.$('.browse.item')
      .popup({
        popup     : '.admission.popup',
        hoverable : true,
        position  : 'bottom left',
        delay     : {
          show: 200,
          hide: 600
        },
        offset: 20,
        distanceAway: -20
      })
    ;
  },
  actions: {
    reset() {
      this.sendAction('reset');
    },
    nameSearch() {
      Ember.$('.ui.modal.save-search').modal('show');
    },
    saveSearchesOpen() {
      Ember.$('#saved-searches-modal')
      .modal({
        allowMultiple: true
      })
      .modal('show');
    },
    downloadSearchModal() {
      this.$('.download-unsaved-search').modal('show');
    }
  }
});

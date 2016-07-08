import Ember from 'ember';

var parse = JSON.parse;

export default Ember.Component.extend({
  validRange: function() {
    if (this.get('full_range') == null) {
      return '[null,null]';
    } else {
      return this.get('full_range');
    }
  }.property('full_range'),

  from: function() {
    return this._toArray(this.get('validRange'))[0];
  }.property('full_range'),

  to: function() {
    return this._toArray(this.get('validRange'))[1];
  }.property('full_range'),

  _toArray: function(full_range) {
    return JSON.parse(full_range);
  },

  _toString: function(from,to) {
    return `[${from},${to}]`;
  },

  _resetProperty: function() {
    var from = this.get('from');
    var to = this.get('to');
    this.set('full_range', this._toString(from,to));
  }.observes('from', 'to')
});

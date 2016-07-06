import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import Ember from 'ember';

moduleForComponent('mapbox-map', 'Integration | Component | mapbox map', {
  integration: true
});

test('it renders', function(assert) {
  
  assert.expect(2);
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });" + EOL + EOL +
  var development = Ember.Object.extend({ longitude: 0, 
                                          latitude: 0, 
                                          name: 'Development', 
                                          id: 1, 
                                          year: 2000 }).create();

  this.set('developments', [development]);

  this.render(hbs`{{mapbox-map developments=developments}}`);

  assert.equal(this.$().text().trim(), 'Name\n    Completion Year\n    Total Housing Units\n    Commercial Square Feet\n    Municipality');

  assert.ok(this.$('canvas').length);

});

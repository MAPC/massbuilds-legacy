import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('range-field-group', 'Integration | Component | range field group', {
  integration: true
});

test('it renders', function(assert) {
  
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });" + EOL + EOL +

  this.render(hbs`{{range-field-group}}`);

  assert.equal(this.$('div').attr('class'), 'ember-view', 'it renders');

  // Template block usage:" + EOL +
  this.render(hbs`
    {{#range-field-group}}
      template block text
    {{/range-field-group}}
  `);

  assert.equal(this.$('div').attr('class'), 'ember-view', 'it renders with block');
});

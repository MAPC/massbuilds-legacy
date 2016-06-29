import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('toggle-label', 'Integration | Component | toggle label', {
  integration: true
});

test('it renders', function(assert) {
  
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });" + EOL + EOL +
  assert.expect(3);
  this.render(hbs`{{toggle-label}}`);

  assert.equal(this.$().text().trim(), '');

  this.set('booleanValue', false);
  // Template block usage:" + EOL +
  this.render(hbs`
    {{#toggle-label field=booleanValue label="Redevelopment"}}
      template block text
    {{/toggle-label}}
  `);

  this.$('.label').click();

  assert.equal(this.$('a').attr('class'), 'ember-view ui label blue');

  this.$('.label').click();

  assert.equal(this.$('a').attr('class'), 'ember-view ui label');
});

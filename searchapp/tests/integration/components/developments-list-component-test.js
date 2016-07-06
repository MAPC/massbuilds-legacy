import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('developments-list-component', 'Integration | Component | developments list component', {
  integration: true
});

test('it renders', function(assert) {
  
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });" + EOL + EOL +

  this.render(hbs`{{developments-list-component}}`);

  assert.equal(this.$().text().trim(), 'Name\n    Completion Year\n    Total Housing Units\n    Commercial Square Feet\n    Municipality');

  // Template block usage:" + EOL +
  this.render(hbs`
    {{#developments-list-component}}
      template block text
    {{/developments-list-component}}
  `);

  assert.equal(this.$().text().trim(), 'Name\n    Completion Year\n    Total Housing Units\n    Commercial Square Feet\n    Municipality');
});

import { moduleForModel, test } from 'ember-qunit';

moduleForModel('development', 'Unit | Model | development', {
  // Specify the other units that are required for this test.
  needs: ['model:team-membership', 'model:development-team-membership']
});

test('it exists', function(assert) {
  let model = this.subject();
  // let store = this.store();
  assert.ok(!!model);
});

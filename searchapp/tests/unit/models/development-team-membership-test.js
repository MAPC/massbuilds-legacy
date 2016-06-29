import { moduleForModel, test } from 'ember-qunit';

moduleForModel('development-team-membership', 'Unit | Model | development team membership', {
  // Specify the other units that are required for this test.
  needs: ['model:development','model:organization']
});

test('it exists', function(assert) {
  let model = this.subject();
  // let store = this.store();
  assert.ok(!!model);
});

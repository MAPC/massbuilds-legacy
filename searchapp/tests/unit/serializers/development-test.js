import { moduleForModel, test } from 'ember-qunit';

moduleForModel('development', 'Unit | Serializer | development', {
  // Specify the other units that are required for this test.
  needs: ['serializer:development, model:team-membership']
});

// Replace this with your real tests.
test('it serializes records', function(assert) {
  let record = this.subject();

  let serializedRecord = record.serialize();

  assert.ok(serializedRecord);
});

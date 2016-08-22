class DevelopmentSummaryOperationsProcessor < ActiveRecordOperationsProcessor
  after_find_operation do
    @operation_meta[:record_count] = @operation.record_count
    @operation_meta[:methods] = @operation.methods - Object.new.methods
  end
end

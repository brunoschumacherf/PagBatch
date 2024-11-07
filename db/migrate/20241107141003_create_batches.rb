class CreateBatches < ActiveRecord::Migration[7.2]
  def change
    create_table :batches do |t|
      t.string :status
      t.datetime :processed_at

      t.timestamps
    end
  end
end

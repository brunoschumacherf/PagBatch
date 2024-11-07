class CreateBoletos < ActiveRecord::Migration[7.2]
  def change
    create_table :boletos do |t|
      t.string :barcode
      t.decimal :valor
      t.string :status
      t.references :batch, null: false, foreign_key: true

      t.timestamps
    end
  end
end

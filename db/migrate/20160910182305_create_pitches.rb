class CreatePitches < ActiveRecord::Migration[5.0]
  def change
    create_table :pitches do |t|
      t.string :url
      t.string :email

      t.timestamps
    end
  end
end

class CreatePitches < ActiveRecord::Migration[5.0]
  def change
    create_table :pitches do |t|
      t.string  :video
      t.string  :contact_info
      t.integer :status
      t.string  :ip
      t.string  :location

      t.timestamps
    end
  end
end

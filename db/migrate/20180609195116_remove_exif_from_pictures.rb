class RemoveExifFromPictures < ActiveRecord::Migration[5.2]
  def up
    remove_column :pictures, :aperture, :float
    remove_column :pictures, :camera, :string
    remove_column :pictures, :dimensions, :text
    remove_column :pictures, :flash, :integer
    remove_column :pictures, :focal_length, :float
    remove_column :pictures, :iso_speed, :integer
    remove_column :pictures, :photographed_at, :datetime
    remove_column :pictures, :shutter_speed, :string
  end

  def down
    add_column :pictures, :aperture, :float
    add_column :pictures, :camera, :string
    add_column :pictures, :dimensions, :text
    add_column :pictures, :flash, :integer
    add_column :pictures, :focal_length, :float
    add_column :pictures, :iso_speed, :integer
    add_column :pictures, :photographed_at, :datetime
    add_column :pictures, :shutter_speed, :string
  end
end

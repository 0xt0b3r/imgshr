class RemovePaperclipFromPictures < ActiveRecord::Migration[5.2]
  def change
    change_column :pictures, :image_fingerprint, :string, null: true

    remove_column :pictures, :image_content_type, :string
    remove_column :pictures, :image_file_name, :string
    remove_column :pictures, :image_file_size, :integer
    remove_column :pictures, :image_updated_at, :datetime
  end
end

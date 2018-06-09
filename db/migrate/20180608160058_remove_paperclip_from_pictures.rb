class RemovePaperclipFromPictures < ActiveRecord::Migration[5.2]
  def up
    change_column :pictures, :paperclip_image_fingerprint, :string, null: true

    remove_column :pictures, :paperclip_image_content_type, :string
    remove_column :pictures, :paperclip_image_file_name, :string
    remove_column :pictures, :paperclip_image_file_size, :integer
    remove_column :pictures, :paperclip_image_updated_at, :datetime
  end

  def down
    change_column :pictures, :paperclip_image_fingerprint, :string, null: false

    add_column :pictures, :paperclip_image_content_type, :string
    add_column :pictures, :paperclip_image_file_name, :string
    add_column :pictures, :paperclip_image_file_size, :integer
    add_column :pictures, :paperclip_image_updated_at, :datetime
  end
end

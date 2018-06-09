class RenamePaperclipColumns < ActiveRecord::Migration[5.2]
  def change
    rename_column :pictures, :image_content_type, :paperclip_image_content_type
    rename_column :pictures, :image_file_name, :paperclip_image_file_name
    rename_column :pictures, :image_file_size, :paperclip_image_file_size
    rename_column :pictures, :image_fingerprint, :paperclip_image_fingerprint
    rename_column :pictures, :image_updated_at, :paperclip_image_updated_at

    add_column :pictures, :image_fingerprint, :string

    rename_column :file_releases, :file_content_type, :paperclip_file_content_type
    rename_column :file_releases, :file_file_name, :paperclip_file_file_name
    rename_column :file_releases, :file_file_size, :paperclip_file_file_size
    rename_column :file_releases, :file_fingerprint, :paperclip_file_fingerprint
    rename_column :file_releases, :file_updated_at, :paperclip_file_updated_at
  end
end

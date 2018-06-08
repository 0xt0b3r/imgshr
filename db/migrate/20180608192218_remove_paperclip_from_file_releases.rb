class RemovePaperclipFromFileReleases < ActiveRecord::Migration[5.2]
  def change
    remove_column :file_releases, :file_content_type, :string
    remove_column :file_releases, :file_file_name, :string
    remove_column :file_releases, :file_file_size, :integer
    remove_column :file_releases, :file_fingerprint, :string
    remove_column :file_releases, :file_updated_at, :datetime
  end
end

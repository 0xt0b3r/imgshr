class ChangePicturesImageFingerprintDefault < ActiveRecord::Migration[5.2]
  def change
    change_column :pictures, :image_fingerprint, :string, null: true
  end
end

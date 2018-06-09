class PictureImageValidator < ActiveModel::Validator
  def validate(record)
    unless record.image.attached?
      record.errors[:base] << 'Image missing'
      return
    end

    if record.plain?
      if !record.image.blob.content_type.starts_with?('image/')
        record.image.purge
        errors[:base] << 'Wrong image format'
      end
    else
      if record.image.blob.content_type != 'application/octet-stream'
        record.image.purge
        errors[:base] << 'Wrong image format'
      end
    end
  end
end

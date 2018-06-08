class FileRelease < ApplicationRecord
  has_one_attached :file

  def to_s
    file.filename
  end
end

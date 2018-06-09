class FileRelease < ApplicationRecord
  has_attached_file :paperclip_file,
    url: '/system/:class/:id/:filename'

  has_one_attached :file

  def to_s
    file.filename.to_s
  end
end

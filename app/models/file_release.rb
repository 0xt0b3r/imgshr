class FileRelease < ApplicationRecord
  has_one_attached :download

  has_attached_file :file,
    url: '/system/:class/:id/:filename'

  # validates_attachment_content_type :file, content_type: /\Aapplication\/java-archive/
  do_not_validate_attachment_file_type :file

  def to_s
    download.filename.to_s
  end
end

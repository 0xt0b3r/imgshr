class Picture < ActiveRecord::Base
  belongs_to :gallery, touch: true

  has_many :ratings

  serialize :dimensions

  has_attached_file :image,
    styles: {medium: '550x550>', thumb: '200x200>'},
    url: '/system/:hash.:extension',
    hash_secret: Rails.application.secrets[:secret_key_base]

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  after_image_post_process :set_exif_attributes!
  before_save :set_height_and_width!

  scope :grid, -> { order('created_at desc') }

  paginates_per 16

  def average_rating
    (ratings.sum(:score) / ratings.count.to_f).round(2)
  end

  def height(size = :original)
    dimensions[size][:height]
  end

  def image_fingerprint_short
    @image_fingerprint_short ||= image_fingerprint[0..7]
  end

  def next_id
    @next_id ||= gallery.next_picture_id(id)
  end

  def photographed_or_created_at
    photographed_at || created_at
  end

  def previous_id
    @previous_id ||= gallery.previous_picture_id(id)
  end

  def to_s
    title.blank? ? 'Untitled picture' : title
  end

  def width(size = :original)
    dimensions[size][:width]
  end

  private

  def set_exif_attributes!
    exif = nil

    path = begin
      image.queued_for_write[:original].path
    rescue NoMethodError
      image.path
    end

    begin
      exif = EXIFR::JPEG.new(path)
    rescue EXIFR::MalformedJPEG
    end

    if exif && exif.exif?
      camera = exif.model

      if !(exif.make.blank? || camera.starts_with?(exif.make))
        camera = [exif.make, camera].join(' ')
      end

      self.camera = camera
      self.photographed_at = exif.date_time_digitized

      unless exif.focal_length.nil?
        self.focal_length  = exif.focal_length.to_f.round(3)
      end

      self.aperture      = exif.aperture_value || exif.f_number
      self.shutter_speed = exif.shutter_speed_value || exif.exposure_time
      self.iso_speed     = exif.iso_speed_ratings
      self.flash         = exif.flash

      exif
    end
  end

  def set_height_and_width!
    self.dimensions = {}

    hash = image.queued_for_write

    if hash.empty?
      hash = {}
      %i[original medium thumb].each do |size|
        hash[size] = image.path(size)
      end
    end
    
    hash.each do |size, file|
      geometry = Paperclip::Geometry.from_file(file)
      self.dimensions[size] = {
        width:  geometry.width.to_i,
        height: geometry.height.to_i
      }
    end
  end
end

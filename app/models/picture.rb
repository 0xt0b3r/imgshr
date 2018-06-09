class Picture < ApplicationRecord
  belongs_to :gallery, touch: true

  has_many :ratings, dependent: :destroy
  has_many :temp_links, dependent: :destroy

  has_attached_file :paperclip_image,
    url: '/system/:hash.:extension',
    hash_secret: Rails.application.secrets[:secret_key_base]

  has_one_attached :image

  acts_as_taggable_on :tags, :labels

  validates_with PictureImageValidator

  validates :image_fingerprint,
    uniqueness: {
      scope: :gallery_id,
      message: 'Picture already exists in gallery!'
    }

  before_create :set_order_date!
  after_create :set_image_fingerprint!

  if !::Settings.foreground_processing && LabelImage.is_enabled?
    # TODO after_image_post_process without delay
    after_create :enqueue_label_job
  end

  scope :by_order_date, -> { order('order_date desc') }
  scope :by_created_at, -> { order('created_at desc') }

  scope :since, ->(date) { where('order_date >  ?', Date.parse(date)) }
  scope :until, ->(date) { where('order_date <= ?', Date.parse(date)) }

  scope :min_rating, ->(score) { joins(:ratings).where('ratings.score >= ?', score) }
  scope :max_rating, ->(score) { joins(:ratings).where('ratings.score <= ?', score) }

  paginates_per 12

  def average_rating
    (ratings.sum(:score) / ratings.count.to_f).round(2)
  end

  def image_fingerprint_short
    @image_fingerprint_short ||= image_fingerprint[0..7]
  end

  def photographed_or_created_at
    photographed_at || created_at
  end

  # TODO Referal of pictures by fingerprint assumes they are unique. Actually,
  #      we also need a slug, here.
  def to_param
    image_fingerprint_short
  end

  def to_s
    title.blank? ? 'Untitled picture' : title
  end

  def label_image!
    ds = ActiveStorage::Service::DiskService.new(root: Rails.root.join('storage'))
    path = ds.send(:path_for, self.image.blob.key)

    process = LabelImage::Process.new(path)
    raw_label_list = process.run!

    self.raw_label_list = raw_label_list.to_json
    self.label_list = process.labels_above_threshold

    save!
  end

  def raw_label_list_hash
    JSON.parse(raw_label_list)
  end

  def plain?
    gallery && !gallery.client_encrypted
  end

  def photographed_at
    image.metadata[:photographed_at]
  end

  def photographed_at?
    !!photographed_at
  end

  def self.filtered(params)
    pictures = all

    # Untagged
    pictures = pictures.tagged_with(ActsAsTaggableOn::Tag.all.map(&:to_s), exclude: true) unless params[:untagged].blank?

    # Tags
    pictures = pictures.tagged_with(params[:tags]) unless params[:tags].blank?

    # Since date
    pictures = pictures.since(params[:since]) unless params[:since].blank?

    # Until date
    pictures = pictures.until(params[:until]) unless params[:until].blank?

    # Minimum rating
    pictures = pictures.min_rating(params[:min_rating]) unless params[:min_rating].blank?

    # Maximum rating
    pictures = pictures.max_rating(params[:max_rating]) unless params[:max_rating].blank?

    pictures
  end

  def self.first_by_fingerprint!(fp)
    if fp.size == 8
      where('image_fingerprint like ?', "#{fp}%").first!
    else
      find_by_image_fingerprint!(fp)
    end
  end

  private

  def set_order_date!
    if self.photographed_at?
      self.order_date = self.photographed_at
    elsif self.created_at?
      self.order_date = self.created_at
    else
      # order_date should be set to created_at but that's not available in
      # before_create. Time.now should be close enough.
      self.order_date = Time.now
    end

    true
  end

  def set_image_fingerprint!
    update_attributes! \
      image_fingerprint: Digest::SHA1.hexdigest(self.image.download)
  end

  def enqueue_label_job
    LabelImageJob.set(wait: 25.seconds).perform_later(self)
  end
end

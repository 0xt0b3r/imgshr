# Gallery, Picture
gallery = Gallery.create!

file = File.open(Rails.root.join('public/images/emsi.png'))
picture = gallery.pictures.build
picture.image.attach(io: file, filename: 'emsi.png')
picture.save!

# FileRelease
fr = FileRelease.new
fr.file = File.open(Rails.root.join('README.md'))
fr.version = 1
fr.save!

# Print Gallery URL
Rails.logger = Logger.new($stdout)
Rails.logger.info "http://localhost:3000/!#{gallery.slug}"

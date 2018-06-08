class PictureTest < ActiveSupport::TestCase
  describe 'image' do
    let(:gallery) { Gallery.create! }
    subject { gallery.pictures.build }

    it 'should attach image' do
      subject.image.attach(io: emsi(), filename: 'emsi.png')
      subject.save!

      subject.image.wont_be_nil
    end
  end
end

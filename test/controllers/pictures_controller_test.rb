require 'test_helper'

class PicturesControllerTest < ActionController::TestCase
  describe :picture do
    let(:gallery) { Gallery.create! }

    subject do
      pic = gallery.pictures.build
      pic.image.attach(io: emsi(), filename: 'emsi.png')
      pic.save!
      pic
    end

    it 'update title' do
      put :update, params: { slug: gallery , id: subject, picture: { title: 'foo' } }, xhr: true
      response.must_be :successful?
      Picture.last.title.must_equal 'foo'
    end

    it 'update tag_list' do
      put :update, params: { slug: gallery , id: subject, picture: { tag_list: 'foo, bar' } }, xhr: true
      response.must_be :successful?
      Picture.last.tag_list.must_equal ['foo', 'bar']
    end
  end
end

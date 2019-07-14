# frozen_string_literal: true

if Rails.application.config.active_storage.service == :local
  module ActiveStorage
    class RepresentationsController < BaseController
      include ActiveStorage::SetBlob

      def show
        expires_in 1.year, public: true

        variant = @blob.representation(params[:variation_key]).processed

        if variant.is_a? ActiveStorage::Preview
          expires_in ActiveStorage::Blob.service.url_expires_in

          redirect_to @blob
            .representation(params[:variation_key])
            .processed
            .service_url(disposition: params[:disposition])

          return
        end

        send_data @blob.service.download(variant.key),
          type: @blob.content_type || DEFAULT_SEND_FILE_TYPE,
          disposition: 'inline'
      end
    end
  end
end

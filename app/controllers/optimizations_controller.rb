# frozen_string_literal: true

# OptimizationsController
class OptimizationsController < ApplicationController
  include ProcessImage

  ##
  # If there's an error, return it, otherwise return the image
  # End_point:
  #   POST: /optimizations?width=200&height=200&threshold=100000
  # Params:
  #   width: Specify maximum image width when resizing an image
  #   height: Specify maximum image height when resizing an image
  #   threshold: Specify a threshold data size to be used to decide whether we should resize an image or not
  #
  def create
    process_data = process_image(params)
    if process_data[:error].present?
      render json: { error: process_data[:error] }, status: 400
    else
      image = process_data[:image_obj]
      send_file(
        File.open(image.path), filename: "#{process_data[:filename]}#{File.extname(image.path)}",
                               disposition: 'inline', content_type: image.mime_type
      )
    end
  end

  # def create
  #   send_file(
  #     params.require(:image),
  #     filename: params[:image].original_filename,
  #     disposition: 'inline',
  #     content_type: params[:image].content_type
  #   )
  # end
end

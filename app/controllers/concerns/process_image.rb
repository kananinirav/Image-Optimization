# frozen_string_literal: true

# ProcessImage
module ProcessImage
  extend ActiveSupport::Concern
  require 'mini_magick'

  ##
  # It takes in a hash of parameters, validates them, and returns a hash of the image object and the
  # filename and f parameters not valid return error
  #
  # Args:
  #   params: The parameters that are passed to the controller.
  #
  # Returns:
  #   A hash with two keys, image_obj and filename or A hash with one key error.
  def process_image(params)
    default_val_set
    image = MiniMagick::Image.open(File.new(params[:image]))
    size_byte = image.size
    validate_params = params_validation(params)
    return { error: validate_params } if validate_params.present?

    width = params_check(params[:width], @width_info[:default])
    height = params_check(params[:height], @height_info[:default])
    threshold = params_check(params[:threshold], @threshold_info[:default])
    filename = 'response2'
    image.resize("#{width}x#{height}")

    if size_byte > threshold
      image.format 'webp'
      filename = 'response1'
    end
    { image_obj: image, filename: filename }
  end

  ##
  # It sets the default values for the width, height, and threshold
  def default_val_set
    @width_info = { default: 200, minimum: 50, maximum: 2000 }
    @height_info = { default: 200, minimum: 50, maximum: 2000 }
    @threshold_info = { default: 1_000_000, minimum: 100_000, maximum: 100_000_000 }
  end

  ##
  # It checks if the parameters are valid
  #
  # Args:
  #   params: The parameters that are passed in from the request.
  def params_validation(params)
    error_message = []
    # p number_between_check(params[:width]&.to_i, @width_info[:minimum], @width_info[:maximum])
    unless number_between_check(params[:width], @width_info[:minimum], @width_info[:maximum])
      error_message << 'Invalids Parameter width'
    end
    unless number_between_check(params[:height], @height_info[:minimum], @height_info[:maximum])
      error_message << 'Invalids Parameter height'
    end
    unless number_between_check(params[:threshold], @threshold_info[:minimum], @threshold_info[:maximum])
      error_message << 'Invalids Parameter threshold'
    end
    error_message
  end

  ##
  # It checks if a value is between two numbers
  #
  # Args:
  #   value: The value to check
  #   min_val: The minimum value that the number can be.
  #   max_val: The maximum value that the number can be.
  #
  # Returns:
  #   true or false
  def number_between_check(value, min_val, max_val)
    return true unless value.present?

    value&.to_i&.between?(min_val, max_val)
  end

  ##
  # If the value is present, return the value converted to an integer, otherwise return the default
  # value
  #
  # Args:
  #   value: The value of the parameter that is being checked.
  #   default: The default value to be returned if the value is not present.
  def params_check(value, default)
    value.present? ? value&.to_i : default
  end
end

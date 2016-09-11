class PitchesController < ApplicationController
  def upload
    #extract the video data from params
    video = params[:video]

    # define the save path for the video. I am using public directory for the moment.
    save_path = Rails.root.join("public/videos/#{video.original_filename}")

    # Open and write the file to file system.
    File.open(save_path, 'wb') do |f|
      f.write params[:video].read
    end

    render :nothing => true
  end
end

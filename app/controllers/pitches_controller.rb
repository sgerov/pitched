class PitchesController < ApplicationController
  def upload
    dirname = Rails.root.join('public/pitches/')
    FileUtils.mkdir_p(dirname) unless File.directory?(dirname)

    # just save in hard disk for prototype
    params[:files].each do |video|
      name = video.original_filename
      path = File.join(dirname, name)
      File.open(path, "wb") { |f| f.write(video.read) }
    end if params[:files]

    render :nothing => true
  end
end

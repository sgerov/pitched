class PitchesController < ApplicationController
  def upload
    dirname = Rails.root.join('public/pitches/')
    FileUtils.mkdir_p(dirname) unless File.directory?(dirname)

    # just save in hard disk for prototype, no validations
    params[:files].each do |video|
      name = video.original_filename
      path = File.join(dirname, name)
      File.open(path, "wb") { |f| f.write(video.read) }

      if p = Pitch.create(video: path, contact_info: params[:contact].downcase, ip: request.remote_ip)
        Delayed::Job.enqueue RetrieveLocationJob.new(p.id)
      end
    end if params[:files]

    render :nothing => true
  end
end

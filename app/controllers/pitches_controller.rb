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

  def status
    msg = case Pitch.find_by(contact_info: params[:q].downcase).try(:status)
    when 'uploaded'
      "UPLOADED. WILL BE REVIEWED SOON"
    when 'in_review'
      "APPLICATION IS UNDER REVIEW"
    when 'reviewed'
      "REVIEWED. WE WILL BE IN TOUCH VERY SOON"
    else
      "APPLICATION NOT FOUND. PLEASE RETRY"
    end

    render text: msg
  end

  # private

  # def pitch_params
  # end
end

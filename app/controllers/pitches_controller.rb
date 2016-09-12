class PitchesController < ApplicationController
  def index
    @reviews = Pitch.all.order(created_at: 'desc').limit(9)
    @reviews = @reviews.where(contact_info: params[:contact]) if params[:contact]
    @reviews = @reviews.where(status: params[:status]) if params[:status]
    @reviews = @reviews.where(location: params[:location]) if params[:location]
  end

  def update
    # haha, it's a prototype, ok?
    if pitch = Pitch.find(params[:id])
      pitch.update(status: pitch.status_before_type_cast + 1) unless pitch.status == 'reviewed'
      render text: pitch.status_msg and return
    end

    render nothing: true
  end

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

    render nothing: true
  end

  def status
    render text: Pitch.find_by(contact_info: params[:q].downcase).try(:status_msg)
  end

  # private

  # def pitch_params
  # end
end

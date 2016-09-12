class Pitch < ApplicationRecord
  enum status: [:uploaded, :in_review, :reviewed]

  def status_msg
    case self.status
    when 'uploaded'
      "UPLOADED. WILL BE REVIEWED SOON"
    when 'in_review'
      "APPLICATION IS UNDER REVIEW"
    when 'reviewed'
      "APPLICATION REVIEWED 👍"
    else
      "YOUR IDEA IS FUNDED"
    end
  end
end

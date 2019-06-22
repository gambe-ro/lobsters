class Invitation < ActiveRecord::Base
  belongs_to :user

  validate do
    unless email.to_s.match(/\A[^@ ]+@[^ @]+\.[^ @]+\z/)
      errors.add(:email, "non valida")
    end
  end

  before_validation :create_code,
    :on => :create

  after_save { |invite| User.find(invite.user_id).update_invitations_sent_count! }

  def create_code
    (1...10).each do |tries|
      if tries == 10
        raise "too many hash collisions"
      end

      self.code = Utils.random_str(15)
      unless Invitation.exists?(:code => self.code)
        break
      end
    end
  end

  def send_email
    InvitationMailer.invitation(self).deliver_now
  end
end

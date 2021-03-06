# == Schema Info
# Schema version: 20090303034616
#
# Table name: pin_emails
#
#  id         :integer(4)      not null, primary key
#  pin_id     :integer(4)
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime

class PinEmail < ActiveRecord::Base
  belongs_to :pin
  belongs_to :user
  
  def self.pin_created(pin)
    unless exists_for_pin?(pin)
      if pin.user
        if pin.added_by_admin
          UserMailer.deliver_pin_created_by_admin(pin)
        else
          UserMailer.deliver_pin_created_by_user(pin)
        end
        PinEmail.create(:pin => pin, :user => pin.user)
      end
    end
  rescue Net::SMTPSyntaxError
  end
  
  def self.exists_for_pin?(pin)
    PinEmail.find_by_pin_id(pin.id)
  end
  
end

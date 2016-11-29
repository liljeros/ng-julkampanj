require 'users_helper'

class User < ActiveRecord::Base
  belongs_to :referrer, class_name: 'User', foreign_key: 'referrer_id'
  has_many :referrals, class_name: 'User', foreign_key: 'referrer_id'

  validates :email, presence: true, uniqueness: true, format: {
    with: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i,
    message: 'Invalid email format.'
  }
  validates :referral_code, uniqueness: true

  before_create :create_referral_code
  after_create :send_welcome_email

  REFERRAL_STEPS = [
    {
      'count' => 5,
      'html' => '200 kr* presentkort<br> på nordiskagalleriet.se',
      'class' => 'two',
      'image' =>  ActionController::Base.helpers.asset_path(
        'refer/presentkort@2x.png')
    },
    {
      'count' => 10,
      'html' => 'Stor serveringsbricka <br> ”The Usual Crowd"<br> <span>Värde 395 kr</span>',
      'class' => 'three',
      'image' => ActionController::Base.helpers.asset_path(
        'refer/bricka@2x.png')
    },
    {
      'count' => 25,
      'html' => '2 st 50x50 kuddar <br>Nordiska Galleriet <br><span>Värde 1 800 kr</span>',
      'class' => 'four',
      'image' => ActionController::Base.helpers.asset_path(
        'refer/kuddar@2x.png')
    },
    
  ]

  private

  def create_referral_code
    self.referral_code = UsersHelper.unused_referral_code
  end

  def send_welcome_email
    UserMailer.delay.signup_email(self)
  end
end

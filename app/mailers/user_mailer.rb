class UserMailer < ActionMailer::Base
  default from: "Nordiska Galleriet <mobel@harrys.com>"

  def signup_email(user)
    @user = user
    @twitter_message = "Nordiska Galleriets jultävling där alla kan vinna."

    mail(:to => user.email, :subject => "Tack för att du skrivit upp dig på vår maillista och varit med i tävlingen.")
  end
end

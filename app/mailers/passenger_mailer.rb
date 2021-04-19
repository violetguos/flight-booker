class PassengerMailer < ApplicationMailer
  default from: 'notifications@example.com'
  def thank_you_email
    @passenger = params[:passenger]
    @url = bookings_url
    mail(to: @passenger.email,
         subject: "Thank you for booking a Flight!")
  end
end

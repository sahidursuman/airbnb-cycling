require 'rails_helper'

feature "Member reserves a location" do 
  let(:location) { FactoryGirl.create(:location) }
  let(:member) { FactoryGirl.create(:member, email: "kitty@bikes.com") }

  before do 
    login_as(member, scope: :member)
  end

  scenario "by visiting location show page and selecting dates", js: true do
    visit location_path(location)
    expect(page).to have_content location.description

    execute_script("
      $('#datepicker-start').pickadate('picker').set(
        'select', new Date((new Date)()).valueOf() + 1000*3600*24),
        { format: 'yyyy-mm-dd' });"
      )
    execute_script("
      $('#datepicker-start').pickadate('picker').set(
        'select', new Date((new Date)()).valueOf() + 1000*3600*48),
        { format: 'yyyy-mm-dd' });"
      )

    click_button "Make a Reservation"
    expect(page).to have_content "Reservation summary:"
    click_button "Confirm Reservation"

    expect(page).to have_content "Reservation successfully created."
    expect(page).to have_content "Thanks for booking with us!"

    expect(Reservation.count).to eq 1
    reservation = Reservation.last
    expect(reservation.location_id).to eq location.id 
    expect(reservation.member_id).to eq member.id
    expect(reservation.start_date).to eq Date.tomorrow
    expect(reservation.end_date).to eq Date.today + 2.days

    let(:location) { FactoryGirl.create(:location_with_available_dates) }

      first_available_date = AvailableDate.first 
      second_available_date = AvailableDate.second 
      expect(first_available_date.booked).to eq true
      expect(second_available_date.booked).to eq false
  end
end

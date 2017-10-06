require 'faker'

if Rails.env.staging? || Rails.env.development?
  Doorkeeper::Application.find_or_create_by!(
    name:'android', redirect_uri: 'https://dev.whatsup.com',
    uid: "0a97a553e51126e08b024173facf767e87b944fc85ddb863529b9507845b114d"
  )
end

categories = ['Academic', 'Arts Exhibit', 'Career/Jobs', 'Concert/Performance', 'Entertainment', 'Health', 'Holiday', 'Meeting', 'Open Forum', 'Recreation & Exercise', 'Service/Volunteer', 'Social Event', 'Speaker/Lecture/Seminar', 'Sports', 'Tour/Open House/Information Session', 'Workshop/Conference', 'Uncategorized/Other']
categories.each { |c| Category.find_or_create_by(name: c) }

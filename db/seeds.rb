require 'faker'

if Rails.env.staging? || Rails.env.development?
  Doorkeeper::Application.find_or_create_by(
    name:'android', redirect_uri: 'https://dev.whatup.com',
    uid: "0a97a553e51126e08b024173facf767e87b944fc85ddb863529b9507845b114d"
  )
end

categories = [ 'Science/Tech', 'Academic', 'Career/Business', 'Arts/Culture', 'Live Performance', 'Health', 'Sports/Recreation', 'Community', 'Informational', 'Leisure', 'Volunteering/Activism', 'Food', 'Religion', 'Other']
categories.each { |c| Category.find_or_create_by(name: c) }

topics = [
  {category_name: 'Science/Tech', name: 'Space'},
  {category_name: 'Science/Tech', name: 'Programming'},
  {category_name: 'Science/Tech', name: 'Bitcoin'},
  {category_name: 'Academic', name: 'Guest Speaker'},
  {category_name: 'Academic', name: 'Thesis Defense'},
  {category_name: 'Career/Business', name: 'Job Fair'},
  {category_name: 'Career/Business', name: 'Q&A'},
  {category_name: 'Arts/Culture', name: 'Exhibit'},
  {category_name: 'Arts/Culture', name: 'Workshop'},
  {category_name: 'Live Performance', name: 'Play'},
  {category_name: 'Live Performance', name: 'Concert'},
  {category_name: 'Health', name: 'Yoga'},
  {category_name: 'Health', name: 'Meditation'},
  {category_name: 'Sports/Recreation', name: 'Soccer'},
  {category_name: 'Sports/Recreation', name: 'Basketball'},
  {category_name: 'Sports/Recreation', name: 'Football'},
  {category_name: 'Community', name: 'Open Forum'},
  {category_name: 'Community', name: 'Vigil'},
  {category_name: 'Informational', name: 'Open House'},
  {category_name: 'Informational', name: 'Lecture'},
  {category_name: 'Leisure', name: 'Hiking'},
  {category_name: 'Leisure', name: 'Movie Night'},
  {category_name: 'Volunteering/Activism', name: 'Demonstration'},
  {category_name: 'Food', name: 'Food Festival'},
  {category_name: 'Food', name: 'Food Truck'},
  {category_name: 'Religion', name: 'Mass'},
]
topics.each do |t| 
  Topic.find_or_create_by(name: t[:name], category_id: Category.find_by_name(t[:category_name]).id)
end

Role.create(name: 'User')
Role.create(name: 'Unverified')
Role.create(name: 'Promoter')
Role.create(name: 'Admin')

# AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

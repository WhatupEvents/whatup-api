class Api::V1::ShoutSerializer < ActiveModel::Serializer
  attributes :id, :text, :created_at, :shouter, :user_id, :event_id, :source, :url

  def text
    blacklist = ['fuck', 'shit', 'cunt']
    blacklist.each do |b|
      sub = ''
      b.length.times{|i| sub+='*'}
      object.text.gsub(b,sub) 
    end
    object.text
  end

  def shouter
    User.find(object.user_id).name
  end
end

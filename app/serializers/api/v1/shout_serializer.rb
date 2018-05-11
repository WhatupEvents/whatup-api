class Api::V1::ShoutSerializer < ActiveModel::Serializer
  attributes :id, :text, :created_at, :shouter, :shouter_url, :user_id, :shouter_id, :event_id, :source, :url, :ups, :upped_by, :flag, :flagged_by, :event_name, :latitude, :longitude, :symbol_id, :category_id, :video_url

  def text
    text = object.text
    blacklist = [/child-.*/,
      /[a]+s[s]+\b/,
      /[a]+s[s]+[e]+s\b/,
      /[s]+[h]+[a]+[t]+\b/,
      /[a]+[r]+[s]+[e]+[s]*/,
      /[a]+[s]+[s]+[h]+[o]+[l]+[e]+[s]*/,
      /[b]+(a|e)+[s]+[t]+(a|e)+[r]+[d]+[s]*/,
      /[b]+(a|e|i)+[t]+[c]+[h]+[e]*[s]*/,
      /[b]+(a|o)+[l]+[o]+[c]+[k]+[s]*/,
      /[c]+[r]+[a]+[p]+/,
      /[d]+[u]+[m]+[b]+/,
      /[d]+(a|e|i)+[m]+[n]+/,
      /[g]+[o]+[d]+[a]+[m]+[n]+/,
      /[m]+[o]+[t]+[h]+[e]+[r]+[f]+(u|a|o)+[c]+[k]+[e]*[r]*[s]*/,
      /[n]+[i]+[g]+(a|e)+[r]*[s]*/,
      /[t]+[w]+[a]+[t]+[s]*/,
      /[w]+[h]+(o|a)+[r]+[e]+[s]*/,
      /[f]+(u|a|o)+[c]+[k]+[e]*[r]*[s]*/,
      /[s]+[h]+(a|e|i)+[t]+[s]*/,
      /[c]+[u]+[n]+[t]+[s]*/]
    blacklist.each do |b|
      match = b.match(text)
      if match
        match = match[0]
        sub = ''
        match.length.times{|i| sub+='*'}
        text = text.gsub(match,sub) 
      else
      end
    end
    return text
  end

  def shouter
    if object.shouter_type == "User"
      User.find(object.shouter_id).first_name
    else
      Organization.find(object.shouter_id).name
    end
  end

  def shouter_url
    if object.shouter_type == "User"
      url = User.find(object.shouter_id).image.url
      unless url.include? "missing.png"
        url.split('whatupevents-images/')[1].split('?')[0].gsub('/', '-').gsub('.','_')
      end
    end
  end

  def video_url
    object.shout_video.present? ? object.shout_video.video.url : ''
  end

  def upped_by
    object.upped_by.include? User.find(serialization_options[:current_user])
  end

  def flagged_by
    object.flagged_by.include? User.find(serialization_options[:current_user])
  end

  def event_name
    Event.find(object.event_id).name
  end

  def latitude
    Event.find(object.event_id).latitude
  end

  def longitude
    Event.find(object.event_id).longitude
  end


  def user_id
    object.shouter_id
  end

  def symbol_id
    Event.find(object.event_id).category_id
  end

  def category_id
    Event.find(object.event_id).category_id
  end
end

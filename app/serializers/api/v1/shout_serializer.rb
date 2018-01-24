class Api::V1::ShoutSerializer < ActiveModel::Serializer
  attributes :id, :text, :created_at, :shouter, :shouter_url, :user_id, :event_id, :source, :url, :ups, :upped_by, :flag, :flagged_by, :event_name

  def text
    text = object.text
    blacklist = [/[a]+[r]+[s]+[e]+[s]*/, /[a]+[s]+[s]+[h]+[o]+[l]+[e]+[s]*/, /[b]+[a|e]+[s]+[t]+[a|e]+[r]+[d]+[s]*/, /[b]+[i|e]+[a|e|i]*[t]+[c]+[h]+[e]*[s]*/, /[b]+[a|o]+[l]+[o]+[c]+[k]+[s]*/, /child-.*/, /[c]+[r]+[a]+[p]+/, /[d]+[a|e|i]+[m]+[n]+/, /[g]+[o]+[d]+[a]+[m]+[n]+/, /[m]+[o]+[t]+[h]+[e]+[r]+[f]+[u|a|o]+[c]+[k]+[e]*[r]*[s]*/, /[n]+[i]+[g]+[a|e]+[r]*[s]*/, /[t]+[w]+[a]+[t]+[s]*/, /[w]+[h]+[o|a]+[r]+[e]+[s]*/, /[f]+[u|a|o]+[c]+[k]+[e]*[r]*[s]*/, /[s]+[h]+[a|e|i]+[t]+[s]*/, /[c]+[u]+[n]+[t]+[s]*/, /[s]+[h]+[a]+[t]+ /]
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
    User.find(object.user_id).first_name
  end

  def shouter_url
    url = User.find(object.user_id).image.url
    unless url.include? "missing.png"
      url.split('whatupevents-images/')[1].split('?')[0].gsub('/', '-').gsub('.','_')
    end
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
end

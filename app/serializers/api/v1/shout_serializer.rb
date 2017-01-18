class Api::V1::ShoutSerializer < ActiveModel::Serializer
  attributes :id, :text, :created_at, :shouter, :user_id, :event_id, :source, :url

  def text
    text = object.text
    blacklist = [/[a]+[r]+[s]+[e]+/, /[a]+[s]+[s]+/, /[a]+[s]+[s]+[h]+[o]+[l]+[e]+/, /[b]+[a|e]+[s]+[t]+[a|e]+[r]+[d]+/, /[b]+[i|a]+[t]+[c]+[h]+/, /[b]+[a|o]+[l]+[o]+[c]+[k]+[s]+/, /child-.*/, /[c]+[r]+[a]+[p]+/, /[d]+[a|e|i]+[m]+[n]+/, /[g]+[o]+[d]+[a]+[m]+[n]+/, /[m]+[o]+[t]+[h]+[e]+[r]+[f]+[u|a|o]+[c]+[k]+[e]+[r]+/, /[n]+[i]+[g]+[a|e]+[r]*/, /[t]+[w]+[a]+[t]+/, /[w]+[h]+[o|a]+[r]+[e]+/, /[f]+[u|a|o]+[c]+[k]+[e]*[r]*/, /[s]+[h]+[i]+[t]+/, /[c]+[u]+[n]+[t]+/]
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
    User.find(object.user_id).name
  end
end

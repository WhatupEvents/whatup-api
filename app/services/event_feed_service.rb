class EventFeedService

  attr_accessor :url
  attr_accessor :events

  def initialize(url = 'http://events.ucf.edu/')
    @url = url
    url += Date.today.strftime('%Y/%m/%d/')
    url += 'feed.json' 
    uri = URI.parse(url)
    req = Net::HTTP::Get.new(uri.to_s)
    res = Net::HTTP.start(uri.host, uri.port) {|http| http.request(req)}
    @events = JSON.parse(res.body)
  end

  def events_to_database
    @events.each do |ev|
      event = Event.find_or_create_by(
        feed_id: ev["id"].to_i
      )

      uri = URI.parse(ev["location_url"])
      req = Net::HTTP::Get.new(uri.to_s)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == "https")
      res = http.request(req)
      parse = Nokogiri::HTML(res.body).document.search("meta[name='geo.position']")

      if parse.length > 0 && parse[0].has_key? 'content'
        loc_array = parse[0]['content'].split(';')
      else
        print parse
        loc_array = ["28.6024","-81.2001"]
      end

      event.update_attributes(
        name: ev["title"],
        details: ActionView::Base.full_sanitizer.sanitize(ev["description"]),
        start_time: Time.parse(ev["starts"]),
        end_at: Time.parse(ev["ends"]),
        created_by_id: 1,
        public: true,
        location: ev["location"],
        symbol_id: 1,
        latitude: loc_array[0],
        longitude: loc_array[1],
        category_id: get_category_id(ev["category"])
      )
    end
  end

  def get_category_id(feed_category)
    cat = 8 #"beer"
    if feed_category == "Academic"
      cat = 4 #"art"
    elsif feed_category == "Arts Exhibit"
      cat = 4 #"art"
    elsif feed_category == "Carrer/Jobs"
      cat = 1 #"fitness"
    elsif feed_category == "Concert/Performance"
      cat = 2 #"music"
    elsif feed_category == "Entertainment"
      cat = 2 #"music"
    elsif feed_category == "Health"
      cat = 5 #"volunteer"
    elsif feed_category == "Holiday"
      cat = 0 #"leisure"
    elsif feed_category == "Meeting"
      cat = 3 #"party"
    elsif feed_category == "Open Forum"
      cat = 5 #"volunteer"
    elsif feed_category == "Recreation & Exercise"
      cat = 1 #"fitness"
    elsif feed_category == "Service/Volunteer"
      cat = 5 #"volunteer"
    elsif feed_category == "Social Event"
      cat = 3 #"party"
    elsif feed_category == "Speaker/Lecture/Seminar"
      cat = 4 #"art"
    elsif feed_category == "Sports"
      cat = 6 #"sports"
    elsif feed_category == "Tour/Open House/Information Session"
      cat = 5 #"volunteer"
    elsif feed_category == "Workshop/Conference"
      cat = 7 #"food"
    end
    return cat
  end
end

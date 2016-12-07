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
      Event.create(
        feed_id: ev["id"].to_i,
        name: ev["title"],
        details: ev["description"],
        start_time: Time.parse(ev["starts"]),
        end_at: Time.parse(ev["ends"]),
        created_by_id: 1,
        public: true,
        location: ev["location"],
        symbol_id: 1,
        latitude: "28.6024",
        longitude: "-81.2001"
      )
    end
  end
end

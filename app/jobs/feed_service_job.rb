class FeedServiceJob
  @queue = :low

  def self.perform()
    EventFeedService.new.events_to_database
  end
end

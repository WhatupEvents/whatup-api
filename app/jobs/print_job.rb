class PrintJob
  @queue = :messages

  def initialize
  end

  def self.perform(message)
    Message.last.update_attributes(text: message)
  end
end

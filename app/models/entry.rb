class Entry < ActiveRecord::Base
  belongs_to :feed
  
  validates_presence_of :feed_id, :url
  validates_uniqueness_of :url
  
  def after_create
    twit_me
    return nil
  end
  
  def twit_me
    begin
      if PLANETOID_CONF[:twitter][:send_updates] && self.published > self.feed.created_at
        httpauth = Twitter::HTTPAuth.new PLANETOID_CONF[:twitter][:user],PLANETOID_CONF[:twitter][:password]
        twit=Twitter::Base.new(httpauth)
        twit.update "#{PLANETOID_CONF[:twitter][:update_prefix]} #{self.title[0..150]} #{self.url}"
      end
    rescue Exception => e
      puts e.message
    end
  end
end

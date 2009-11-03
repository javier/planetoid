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
        generic_message="#{PLANETOID_CONF[:twitter][:update_prefix]} http://planeta.aspgems.com"
        msg="#{PLANETOID_CONF[:twitter][:update_prefix]} #{self.title[0..150]} #{self.url}"
        if msg.size > 140
          max_size=138 - generic_message.size
          msg="#{generic_message} #{self.title[0..max_size]}"
        end
        twit.update msg
      end
    rescue Exception => e
      puts e.message
    end
  end
end

require 'open-uri'

class UpdateTitleJob
  @queue = :update_title_job

  def self.perform(short_url_id)
    url = ShortUrl.find_by(id: short_url_id)

    open("#{url.full_url}") do |f|
      document = Nokogiri::HTML(f)
      title = document.at_css('title').text
      url.update_attribute(:title, title)
    end
  end
end

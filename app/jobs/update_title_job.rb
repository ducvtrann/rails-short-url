class UpdateTitleJob < ApplicationJob
  @queue = :update_title_job

  def self.perform(short_url_id)
    url = ShortUrl.find_by(id: short_url_id)

    uri = URI(url.full_url)
    string_result = Net::HTTP.get(uri)
    title = string_result.match(/<title>(.*?)<\/title>/)[1]
    url.update_attribute(:title, title)
  end
end

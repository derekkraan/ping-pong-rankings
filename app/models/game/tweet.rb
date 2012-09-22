module Game::Tweet
  extend ActiveSupport::Concern

  included do
    before_destroy :remove_tweet

    def tweet_result
      begin
        tweet = Twitter.update("#{winners.map(&:name).to_sentence} beat #{losers.map(&:name).to_sentence} #{winning_score} - #{losing_score}")
        self.tweet_id = tweet.id
        self.save
        tweet
      rescue
        logger.debug "Twitter post failed for Game id: #{id}"
      end
    end

    def remove_tweet
      if self.tweet_id
        begin
          Twitter.status_destroy(self.tweet_id)
          self.tweet_id = nil
          self.save
        rescue
          logger.debug "Tweet could not be deleted for Game id: #{id}"
        end
      else
        true
      end
    end

  end
end

module Game::Tweet
  extend ActiveSupport::Concern

  included do
    after_create :tweet_result
    before_destroy :remove_tweet

    def tweet_contents
      _winners = winners.map{|p| p.twitter.present? ? "@#{p.twitter}" : p.name }.to_sentence
      _losers = losers.map{|p| p.twitter.present? ? "@#{p.twitter}" : p.name }.to_sentence

      "#{_winners} beat #{_losers} #{winning_score} - #{losing_score}"
    end

    def tweet_result
      begin
        tweet = Twitter.update tweet_contents
        self.tweet_id = tweet.id
        save
        tweet
      rescue
        logger.debug "Twitter post failed for Game id: #{id}"
      end
    end

    def remove_tweet
      if tweet_id
        begin
          Twitter.status_destroy(tweet_id)
          true
        rescue
          logger.debug "Tweet could not be deleted for Game id: #{id}"
        end
      else
        true
      end
    end

  end
end

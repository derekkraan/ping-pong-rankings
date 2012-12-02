module ApplicationHelper
  def should_show?(thing)
    method = "should_show_#{thing.class.to_s.downcase}?".to_sym
    if respond_to?(method)
      send(method, thing)
    else
      raise "You must define a helper method: #{method}"
    end
  end

  def should_show_player?(player)
    player.games.count > 0 && (
      player.games.count > 30 && player.games.newest_first.first.created_at > 1.month.ago ||
      player.games.count < 30 && player.games.newest_first.first.created_at > 1.week.ago
    )
  end
end

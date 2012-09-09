module GraphHelper
  include ScriptHelper
  def line_graph(element_id, player)
    y_values = player.rating_histories.map(&:rating)
    options = {
      min: RatingHistory.minimum(:rating),
      max: RatingHistory.maximum(:rating),
      focus_radius: 18,
      #focus_attributes: { opacity: 0.01 },
      dot_radius: 3,
      labels: 1..y_values.count,
      status_bar: true,
      mouseover_attributes: { stroke: 'green' },
    }

    mouseover_callback = %Q(
      function(e, t, i) {
        _top = e.pageY - 10
        _left = e.pageX + 20
        $('body').append('<div class="graph_mouseover badge badge-info" style="position: absolute; top: ' + _top + 'px; left: ' + _left + 'px; z-index: 3;">' + display_labels[i] + '</div>');
      }
    )

    mouseout_callback = %Q(
      function(e, t, i) {
        $('.graph_mouseover').detach();
      }
    )

    click_callback = %Q(
      function(e, t, i) {
      }
    )

    display_labels = ['initial rating'] + player.games.order('created_at asc').each_with_index.map do |g,i|
      team = g.teams.find{ |t| t.players.include? player }
      other_team = g.teams.find{ |t| !t.players.include? player }
      rating_difference = y_values[i+1] - y_values[i]
      if team.players.count > 1
        "(#{rating_difference}) with #{team.players.find{ |p| p != player}.name} against #{other_team.players.map(&:name).to_sentence} (#{rating_difference})"
      else
        "(#{rating_difference}) against #{other_team.players.map(&:name).to_sentence}"
      end
    end

    script = %Q(
      var display_labels = #{display_labels.to_json};
      rating_graph = new Ico.LineGraph(
        #{element_id.to_json},
        #{y_values.to_json},
        $.extend({},
          #{options.to_json},
          { node_onmouseover: #{mouseover_callback || ''}, node_onmouseout: #{mouseout_callback || ''}, node_onclick: #{click_callback}}
        )
      );
    )

    buffer_script script
  end

  def spark_line(element_id, y_values)
    options = {
      highlight: {
        color: '#B00',
      },
      min: RatingHistory.minimum(:rating),
      max: RatingHistory.maximum(:rating),
    }
    buffer_script "new Ico.SparkLine(#{element_id.to_json}, #{y_values.to_json}, #{options.to_json})"
  end
end

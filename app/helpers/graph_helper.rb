module GraphHelper
  include ScriptHelper
  def line_graph(element_id, players, options = {})

    y_values = []
    display_labels = []
    dates = []

    [*players].each do |player|
      dates.push player.games.order('created_at asc').map(&:created_at).map(&:to_date)
      y_values.push player.rating_histories.map(&:rating)

      if options.fetch :group_by_dates, false
        labels = [player.name] * y_values.last.count
      else
        labels = ['initial rating'] + player.games.order('created_at asc').each_with_index.map do |g,i|
          team = g.teams.find{ |t| t.players.include? player }
          other_team = g.teams.find{ |t| !t.players.include? player }
          rating_difference = y_values.last[i+1] - y_values.last[i]
          if team.players.count > 1
            "(#{rating_difference}) with #{team.players.find{ |p| p != player}.name} against #{other_team.players.map(&:name).to_sentence} (#{rating_difference})"
          else
            "(#{rating_difference}) against #{other_team.players.map(&:name).to_sentence}"
          end
        end
      end
      display_labels.push labels
    end

    if options.fetch :group_by_dates, false
      _y_values = []
      _display_labels = []
      _dates = dates.reduce{ |a,b| a + b }.uniq.sort
      (0...y_values.count).each do |i|
        (0...y_values[i].count).each do |j|
          date = dates[i][j]
          _y_values[i] ||= {}
          _display_labels[i] ||= {}
          _y_values[i][date] = y_values[i][j]
          _display_labels[i][date] = display_labels[i][j]
        end
      end
      y_values = _y_values.map &:values
      display_labels = _display_labels.map &:values
      dates = _dates
      x_labels = dates

      buffer_script y_values.to_json
      buffer_script display_labels.to_json
      buffer_script dates.to_json
    end

    colours = ['#00F', '#0F0', '#F00', '#FF0', '#F0F', '#0FF', '#FFF', '#88F', '#8F8', '#F88', '#FF8', '#F8F', '#8FF', '#888', '#008', '#080', '#800', '#880', '#808', '#088']

    options = {
      min: RatingHistory.minimum(:rating),
      max: RatingHistory.maximum(:rating),
      focus_radius: 18,
      dot_radius: 3,
      labels: x_labels ? { values: x_labels, angle: 50 } : (1..y_values.last.count),
      grid: { stroke: '#555' },
      colors: colours.slice(0,y_values.count),
      status_bar: true,
      mouseover_attributes: { stroke: 'green' },
      background: { color: "#777" },
    }.merge options

    mouseover_callback = %Q(
      function(e, t, series_i, i) {
        console.log(t);
        _top = e.pageY - 10;
        _left = e.pageX + 20;
        $('body').append('<div class="graph_mouseover badge badge-info" style="position: absolute; top: ' + _top + 'px; left: ' + _left + 'px; z-index: 3;">' + display_labels[series_i][i] + '</div>');
      }
    )

    mouseout_callback = %Q(
      function(e, t, series_i, i) {
        $('.graph_mouseover').detach();
      }
    )

    click_callback = %Q(
      function(e, t, series_i, i) {
      }
    )

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

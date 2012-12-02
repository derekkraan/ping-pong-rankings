module GraphHelper
  include ScriptHelper
  def line_graph(element_id, players, options = {})

    y_values = []
    display_labels = []
    dates = []

    [*players].each do |player|
      histories = (options.fetch(:group_by_dates, false) ? player.rating_histories.last_per_day.within_last_month.chronological_order : player.rating_histories.within_last_month.chronological_order)
      dates.push    histories.map(&:game).map(&:created_at).map(&:to_date)
      y_values.push histories.map(&:rating)

      if options.fetch :group_by_dates, false
        labels = [player.name] * y_values.last.count
      else
        labels = player.games.order('created_at asc').each_with_index.map do |g,i|
          team = g.teams.find{ |t| t.players.include? player }
          other_team = g.teams.find{ |t| !t.players.include? player }
          rating_difference = y_values.last[i] - y_values.last[i-1]
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
      x_labels = dates

      options = {
        dot_radius: 4,
        curve_amount: 15,
      }.merge options
    end

    colours = ['#C33', '#3C3', '#33C', '#CC3', '#C3C', '#3CC', '#CCC', '#88C', '#8C8', '#C88', '#CC8', '#C8C', '#8CC', '#888', '#338', '#383', '#833', '#883', '#838', '#388']

    options = {
      min: RatingHistory.minimum(:rating),
      max: RatingHistory.maximum(:rating),
      focus_radius: 18,
      dot_radius: 3,
      labels: x_labels ? { values: x_labels, angle: -50 } : (1..y_values.last.count),
      grid: { stroke: '#DDD' },
      colors: colours.slice(0,y_values.count),
      mouseover_attributes: { stroke: 'green' },
      background: { color: "#FFF" },
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
      $('##{element_id}').parents().removeClass('hide');
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

    if y_values.first.present?
      content_tag :script do
        "$(document).ready(function(){#{script}});".html_safe
      end
    end
  end

  def spark_line(element_id, y_values)
    options = {
      highlight: {
        color: '#000',
      },
      min: RatingHistory.minimum(:rating),
      max: RatingHistory.maximum(:rating),
    }
    content_tag :script do
      %Q(
        $(document).ready(function(){
          if ($("##{element_id}").is(':visible')) {
            new Ico.SparkLine(#{element_id.to_json}, #{y_values.to_json}, #{options.to_json})
          }
        })
      ).html_safe
    end
  end
end

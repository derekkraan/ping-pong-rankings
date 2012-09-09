module GraphHelper
  include ScriptHelper
  def line_graph(element_id, y_values)
    options = {
      min: RatingHistory.minimum(:rating),
      max: RatingHistory.maximum(:rating),
      focus_radius: 18,
      #focus_attributes: { opacity: 0 },
      dot_radius: 3,
      labels: 1..y_values.count,
      status_bar: true,
      mouseover_attributes: { stroke: 'green' },
    }
    script = %Q(
      rating_graph = new Ico.LineGraph(#{element_id.to_json}, #{y_values.to_json}, #{options.to_json});
      rating_graph.show_label_onmouseover = function(o, value, attr, serie, i, name) {
        alert('TEST');
      }
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

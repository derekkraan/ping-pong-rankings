module GraphHelper
  include ScriptHelper
  def line_graph(element_id, y_values)
    options = {
      min: RatingHistory.minimum(:rating),
      max: RatingHistory.maximum(:rating),
    }
    buffer_script "new Ico.LineGraph(#{element_id.to_json}, #{y_values.to_json}, #{options.to_json})"
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

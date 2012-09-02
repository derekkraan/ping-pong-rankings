module GameHelper
  def score_button_script(element_id, target_element_id, target_value)
    buffer_script "$('##{element_id}').click(
      function(e)
      {
        e.preventDefault();
        $('##{target_element_id}').val(#{target_value});
      });"
  end
end

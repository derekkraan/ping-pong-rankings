module ScriptHelper

  def buffer_script(script)
    @script_buffer ||= []
    @script_buffer << script
  end

  def print_buffered_scripts
    "$(document).ready(function(){#{@script_buffer.join ";\n"}});".html_safe if @script_buffer.present?
  end
end

module StreakHelper
  def streak_label streak
    if streak > 2
      content_tag :span, class: 'label label-important' do
        case streak
        when 3..5
          "HOT STREAK"
        when 5..10
          "ON FIRE"
        when 10..20
          "MOLTEN"
        else
          "GURU"
        end
      end
    elsif streak < -2
      content_tag :span, class: 'label' do
        "LOSING"
      end
    end
  end
end

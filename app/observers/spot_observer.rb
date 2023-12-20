class SpotObserver < PowerTypes::Observer
  before_update :send_report_whatsapp

  def send_report_whatsapp
    return unless !object.today_report_summary["morning"].empty? && object.users.any?

    object.users.each do |user|
      today_report_variables = today_report_variables(user.user_alias)
      SendWhatsappTemplateJob.perform_now(user.phone, TwilioConstants.show_daily_report_template_sid, today_report_variables)
    end
  end

  private

  def today_report_variables(user_alias)
    {
      "1" => "hoy",
      "2" => object.name,
      "3" => object.today_report_summary["morning"]["wave"],
      "4" => object.today_report_summary["morning"]["wind"],
      "5" => object.today_report_summary["morning"]["wind_direction"],
      "6" => object.today_report_summary["morning"]["period"],
      "7" => object.today_report_summary["afternoon"]["wave"],
      "8" => object.today_report_summary["afternoon"]["wind"],
      "9" => object.today_report_summary["afternoon"]["wind_direction"],
      "10" => object.today_report_summary["afternoon"]["period"],
      "11" => object.today_report_summary["tides"]["Lo"][0] || "-",
      "12" => object.today_report_summary["tides"]["Lo"][1] || "-",
      "13" => object.today_report_summary["tides"]["Hi"][0] || "-",
      "14" => object.today_report_summary["tides"]["Hi"][1] || "-",
      "15" => user_alias,
      "16" => object.windguru_code
    }.transform_values(&:to_s)
  end
end

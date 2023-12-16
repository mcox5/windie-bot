class Spot < ApplicationRecord
  MORNING_HOURS = ["01h", "02h", "03h", "04h", "05h", "06h", "07h", "08h", "09h", "10h", "11h", "12h", "13h"]
  AFTERNOON_HOURS = ["14h", "15h", "16h", "17h", "18h", "19h", "20h", "21h", "22h", "23h", "00h"]

  has_many :user_spots, dependent: :destroy
  has_many :users, through: :user_spots

  def today_report_summary
    daily_report_summary(today)
  end

  def tomorrow_report_summary
    daily_report_summary(tomorrow)
  end

  def next_weekend_report_summary
    report = JSON.parse(self.report)["report"]
    next_friday = Time.zone.now.next_occurring(:friday).beginning_of_day
    next_sunday = next_friday.end_of_week
    weekend_report = report.select { |day_report| Date.parse(day_report) >= next_friday && Date.parse(day_report) <= next_sunday }
    weekend_report.each do |day, _|
      weekend_report[day] = daily_report_summary(day)
    end
    weekend_report
  end

  def next_week_report_summary
    report = JSON.parse(self.report)["report"]
    start_of_next_week = (Time.zone.today + 1.week).beginning_of_week
    end_of_next_week = start_of_next_week.end_of_week
    next_week_report = report.select { |day_report| Date.parse(day_report) >= start_of_next_week && Date.parse(day_report) <= end_of_next_week }
    next_week_report.each do |day, _|
      next_week_report[day] = daily_report_summary(day)
    end
    next_week_report
  end

  def today_tides
    today_report_summary["tides"]
  end

  def tomorrow_tides
    tomorrow_report_summary["tides"]
  end

  def big_wave_alert
    next_week_report_summary.each do |day, day_report|
      if day_report["morning"]["wave"] > 3 || day_report["afternoon"]["wave"] > 3
        return { day => daily_report_summary(day) }
      end
    end
    "No big waves in the next week"
  end

  private

  def daily_report_summary(date)
    day_report = JSON.parse(report)["report"].select { |day| day == date }[date]
    report_hours = day_report.keys - ["tides"]
    morning_hours = report_hours.select { |hour| MORNING_HOURS.include?(hour) }
    afternoon_hours = report_hours.select { |hour| AFTERNOON_HOURS.include?(hour) }
    morning_report = average_report(day_report, morning_hours)
    afternoon_report = average_report(day_report, afternoon_hours)
    {
      "morning" => morning_report,
      "afternoon" => afternoon_report,
      "tides" => day_report["tides"]
    }
  end

  def today
    @today ||= Time.zone.today.strftime("%d. %b. %Y").downcase
  end

  def tomorrow
    @tomorrow ||= (Time.zone.today + 1).strftime("%d. %b. %Y").downcase
  end

  def average_report(data, hours)
    return {} if hours.empty?

    total_wave = total_wind = total_period = 0
    hours.each do |hour|
      hour_data = data[hour]
      if hour_data
        total_wave += hour_data["wave"].to_f
        total_wind += hour_data["wind"].to_f
        total_period += hour_data["period"].to_i
      end
    end
    average_wave = total_wave / hours.length
    average_wind = total_wind / hours.length
    average_period = total_period / hours.length
    wind_direction = data[hours[2]]["wind_direction"]
    {
      "wave" => average_wave.round(1),
      "wind" => average_wind.round(1),
      "period" => average_period,
      "wind_direction" => wind_direction
    }
  end
end

# == Schema Information
#
# Table name: spots
#
#  id                 :bigint(8)        not null, primary key
#  name               :string
#  windguru_code      :integer
#  report             :json
#  report_last_update :date
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

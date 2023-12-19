require 'nokogiri'
require 'selenium-webdriver'
require 'json'

SPANISH_MONTHS = {
  'ene.' => 'Jan',
  'feb.' => 'Feb',
  'mar.' => 'Mar',
  'abr.' => 'Apr',
  'may.' => 'May',
  'jun.' => 'Jun',
  'jul.' => 'Jul',
  'ago.' => 'Aug',
  'sep.' => 'Sep',
  'oct.' => 'Oct',
  'nov.' => 'Nov',
  'dic.' => 'Dec'
}

class ScrappingWindguruJob < ApplicationJob
  queue_as :default

  def perform(location_name)
    spot = Spot.find_by(name: location_name)
    report_info = get_report_info_json(location_name)
    spot.update!(report: report_info.to_json, report_last_update: Time.zone.today)
  end

  private

  def get_report_info_json(location_name)
    puts 'Starting web_scrapping_windguru....'
    windguru_code = WindguruLocations.code(location_name)
    url = "https://www.windguru.cz/#{windguru_code}"
    begin
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--disable-gpu')
      options.add_argument('--headless')
      options.add_argument('--no-sandbox')
      options.add_argument('--disable-software-rasterizer')
      options.binary = ENV['GOOGLE_CHROME_SHIM']
      driver = Selenium::WebDriver.for :chrome, options: options
      driver.get(url)
      sleep(6)
      windguru_table = Nokogiri::HTML(driver.page_source).search('#forecasts-page-content .tabulka')
      report_info = transform_report_to_json(parse_windguru_table(windguru_table))

      tide_button = driver.find_elements(:css, '.wg-table-menu')[0].find_elements(:css, 'li')[6].find_elements(:css, 'a').first
      tide_button.click ## Open tides menu
      tide_explorer_button = driver.find_elements(:css, '.wg-table-menu')[0].find_elements(:css, 'li')[6].find_elements(:css, 'a')[2]
      tide_explorer_button.click ## Open tide window

      driver.switch_to.window(driver.window_handles.last)

      report_tide = get_report_tide(driver)
      complete_report = fusion_reports(report_info, report_tide)

      complete_report
    rescue StandardError => e
      p "Error: #{e.message}"
    ensure
      driver.quit if driver
    end
  end

  def get_report_dates(windguru_table)
    dates = []
    report_info_dates = windguru_table.search('.tr_dates td')
    report_info_dates.each do |element|
      dates.push(element.children.text)
    end
    dates.first(200).map { |date| date.split(".") }
  end

  def get_wind_speed(windguru_table)
    wind_speed = []
    report_info_wind_speed = windguru_table.search('.WINDSPD td')
    report_info_wind_speed.each do |element|
      wind_speed.push(element.children.text)
    end
    return wind_speed.first(200)
  end

  def get_waves_size(windguru_table)
    waves = []
    report_info_waves = windguru_table.search('.HTSGW td')
    report_info_waves.each do |element|
      waves.push(element.children.text)
    end
    waves.first(200)
  end

  def get_waves_period(windguru_table)
    waves_period = []
    report_info_period = windguru_table.search('.PERPW td')
    report_info_period.each do |element|
      waves_period.push(element.children.text)
    end
    waves_period.first(200)
  end

  def get_wind_direction(windguru_table)
    wind_direction = []
    report_info_wind_direction = windguru_table.search('.SMER td span')
    report_info_wind_direction.each do |element|
      wind_direction.push(element.attribute_nodes.first.value)
    end
    wind_direction.first(200)
  end

  def parse_windguru_table(windguru_table)
    {
      report_dates: get_report_dates(windguru_table),
      wind_direction: get_wind_direction(windguru_table),
      wind_speed: get_wind_speed(windguru_table),
      waves: get_waves_size(windguru_table),
      period: get_waves_period(windguru_table)
    }
  end

  def get_report_tide(driver)
    sleep(5)
    tide_explorer_table = Nokogiri::HTML(driver.page_source).search('.tide_explorer_table .dayrow')

    parse_tide_explorer_table(tide_explorer_table)
  end

  def parse_tide_explorer_table(tide_explorer_table)
    tides = {}

    tide_explorer_table.each do |day_tides|
      day = day_tides.children[0].text
      tides[day] = {"Lo" => [], "Hi" => []}

      day_tides.children[1..-1].each do |tide|
        tide_type = tide.children[0].text.rstrip
        tide_time = tide.children[1].children[0].text
        tides[day][tide_type].push(tide_time)
      end
    end

    tides_formatted = {}
    tides.each do |day, tides_info|
      day_formatted = day.gsub(/(\d+\.) (\w{3}\.) (\d+)/) { |match| "#{Regexp.last_match[1]} #{SPANISH_MONTHS[Regexp.last_match[2]]}. #{Regexp.last_match[3]}" }.downcase
      tides_formatted[day_formatted] = tides_info
    end
    tides_formatted
  end

  def transform_report_to_json(report_info)
    report = {}
    report_info[:report_dates].each_with_index do |date_time, i|
      day, hour = date_time
      wave = report_info[:waves][i]
      wind = report_info[:wind_speed][i]
      direction = report_info[:wind_direction][i]
      wave_period = report_info[:period][i]
      report[day] ||= {}
      report[day][hour] = {
        "wave" => wave,
        "wind" => wind,
        "wind_direction" => direction,
        "period" => wave_period
      }
    end
    { "report" => report }
  end

  def fusion_reports(report_info, report_tide)
    first_day_report_tide = report_tide.keys[0]
    initial_day = Date.parse(first_day_report_tide)

    report_info_formatted = {}
    report_info["report"].each_with_index do |(date_str, data), index|
      date_formatted = (initial_day + index).strftime("%d. %b. %Y").downcase
      if date_formatted[0] == "0" then date_formatted[0] = "" end
      report_info_formatted[date_formatted] = data
      report_info_formatted[date_formatted]["tides"] = report_tide[date_formatted] if report_tide[date_formatted]
    end

    { "report" => report_info_formatted }
  end
end

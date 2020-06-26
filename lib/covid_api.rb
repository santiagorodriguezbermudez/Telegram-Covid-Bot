require "uri"
require "net/http"
require 'json'

class CovidApi
  attr_reader :commands
  def initialize
    @url = 'https://api.covid19api.com/'
  end

  public

  def summary
    organize_output(get_information('summary') { |hash| hash['Global'] })
  end

  def countries
    country_array = get_information('summary') { |hash| hash['Countries'] }
    country_array.map! { |el| el['Slug'] }
    country_array.sort
  end

  def country(country)
    country_hash = get_information('total/country/' + country) { |array| array[(array.length) - 1] } if country.ascii_only?
    if country == 'Error'
      'There is no data for this location available, try using the slug name.'
    elsif country_hash
      selected_country_fields = country_hash.select { |k, v| (k == 'Confirmed' || k == 'Country' || k == 'Deaths' || k == 'Recovered' || k == 'Active') }
      text_output = "Country: #{selected_country_fields['Country']}\n"
      selected_country_fields = selected_country_fields.select { |k, v| (k != 'Country') }
      text_output += organize_output(selected_country_fields)
    else
      organize_output(country.split('-').join(' ').capitalize + ' has no data on Api')
    end
  end

  def get_slug_country(input_country)
    country_array = get_information('summary') { |hash| hash['Countries'] }
    country_array_with_slug = country_array.map { |country_hash| country_hash.select { |k, v| k == 'Country' || k == 'Slug' } }
    index = country_array_with_slug.find_index { |el| el['Country'].downcase == input_country.downcase }
    if index
      country_array[index]['Slug']
    else
      'Error'
    end
  end

  private

  def get_information(path)
    url_path = URI(@url + path)
    https = Net::HTTP.new(url_path.host, url_path.port);
    https.use_ssl = true

    request = Net::HTTP::Get.new(url_path)
    response = https.request(request)
    summary_hash = JSON.parse(response.read_body)

    yield(summary_hash)
  end

  def organize_output(object)
    return object if object.is_a? String

    text_output = ''
    object.each do |key, value|
      value = value.to_s.reverse.scan(/\d{1,3}/).join(',').reverse
      key = key.split(/(?=[A-Z])/).join(' ')
      text_output += "#{key}: #{value}\n"
    end
    text_output
  end
end

require "uri"
require "net/http"
require 'json'

class CovidApi
  attr_reader :commands
  def initialize
    @url = 'https://api.covid19api.com/'
    # @commands = get_commands(@url)
  end

  public

  def summary
    get_information('summary') {|hash| hash['Global']}
  end

  def countries
    country_array = get_information('countries') {|array| array.map {|el| el['Country']}}
    country_array.sort
  end

  def country(country)
    country_array = get_information('summary') {|hash| hash['Countries']}
    selected_country = country_array.select {|object| object['Country'] == country}
    selected_country_fields = selected_country[0].select {|k, v| (k != "Date" && k != "CountryCode" && k != "Slug")}
    selected_country_fields
    # selected_country_fields = {}
    # selected_country_fields[:NewConfirmed] = selected_country[0]["NewConfirmed"]
    # selected_country_fields[:TotalConfirmed] = selected_country[0]["TotalConfirmed"]
    # selected_country_fields[:NewDeaths] = selected_country[0]["NewDeaths"]
    # selected_country_fields[:TotalDeaths] = selected_country[0]["TotalDeaths"]
    # selected_country_fields[:NewRecovered] = selected_country[0]["NewRecovered"]
    # selected_country_fields[:TotalRecovered] = selected_country[0]["TotalRecovered"]
    # selected_country_fields[:Date] = selected_country[0]["Date"]
    # selected_country_fields
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

  # def get_commands(input_url)
  #   url = input_url
  #   https = Net::HTTP.new(url.host, url.port);
  #   https.use_ssl = true

  #   request = Net::HTTP::Get.new(url)

  #   response = https.request(request)
  #   response.read_body.each {|msg| }

  #   #Get only the commands that the user wants
  #   filter_hash =  response.read_body.select {|key, value| }
  # end

end
require_relative '../lib/covid_api'
require 'geocoder'

describe CovidApi do
  let(:api) {CovidApi.new}

  describe '#country' do 
  let(:array) { api.countries }

    it 'Returns the selected country when it is given' do
      array.each do |el| 
        p el
        text_output = api.country(el)
        expect(text_output.include?'has no data on Api').to eql(false)
      end
    end

    it 'Returns a String even when given a location that does not have any match' do
      array.each do |slug|
        p slug
        slug = slug.split('-').map{|w| w.capitalize}.join(' ')
        location = Geocoder.search(slug)
        expect(api.country(api.get_slug_country(location.first.country)).class).to eql(String) unless location == []
      end
    end
  end
end


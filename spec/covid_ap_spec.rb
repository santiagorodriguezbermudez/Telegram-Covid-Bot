require_relative '../lib/covid_api'

describe CovidApi do
  let(:api) {CovidApi.new}

  describe '#country' do 
  let(:array) { [] }

    it 'Returns the selected country when it is given' do
      array = api.countries
      array.each do |el| 
        text_output = api.country(el)
        expect(text_output.include?'has no data on Api').to eql(false)
      end
    end

    

  end

end


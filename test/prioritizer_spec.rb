require_relative '../src/prioritizer.rb'
require 'json'

RSpec.describe Prioritizer do
  let(:prioritizer) { Prioritizer.new }

  context 'get critical bugs' do
    let(:bugs_file) { File.open( File.join(File.dirname(__FILE__), './bugs.json'), 'r+' ) }
    let(:bugs) { JSON.parse(bugs_file.read).map{|hash| hash.transform_keys(&:to_sym) } }

    it 'should return only critical priority' do
      response = prioritizer.critical_bugs bugs

      expect(response.size).to eq(11)
      expect(response[0][:priority]).to eq('Crítico')
    end
  end

  context 'split bugs' do
    let(:bugs_file) { File.open( File.join(File.dirname(__FILE__), './bugs_critical.json'), 'r+' ) }
    let(:bugs) { JSON.parse(bugs_file.read).map{|hash| hash.transform_keys(&:to_sym) } }

    it 'should return bugs grouped with 8 hours estimate' do
      response = prioritizer.split_bugs bugs

      expect(response[:list_1][:total_hours]).to eq(8)

      response.each do |key, value|
        expect(value[:bugs].size).to be > 0
      end
    end
  end

  context 'extract bug' do
    let(:bugs) {
      [
        {
          title: 'Bug 1',
          age: '1 dia',
          estimate: '6 horas',
          priority: 'Crítico'
        },
        {
          title: 'Bug 2',
          age: '1 dia',
          estimate: '4 horas',
          priority: 'Crítico'
        },
        {
          title: 'Bug 3',
          age: '1 dia',
          estimate: '2 horas',
          priority: 'Crítico'
        }
      ]
    }

    it 'should return bug that sum less or equals 8 hours' do
      hours = 6
      response = prioritizer.extract_bug bugs, hours

      expect(response[:estimate]).to eq('2 horas')
      expect(bugs.size).to eq(2)
    end

    it 'should return first bug that sum less or equals 8 hours ignoring others' do
      hours = 2
      response = prioritizer.extract_bug bugs, hours

      expect(response[:estimate]).to eq('6 horas')
      expect(bugs.size).to eq(2)
    end

    it 'should return nil if passed hour equal 8' do
      hours = 8
      response = prioritizer.extract_bug bugs, hours

      expect(response).to be_nil
    end

    it 'should return nil if all sum is greater than 8' do
      hours = 7
      response = prioritizer.extract_bug bugs, hours

      expect(response).to be_nil
    end
  end

  context 'extract hour' do
    it 'should return hour int' do
      estimate = "12 horas"
      hour = prioritizer.extract_hour estimate

      expect(hour).to eq(12)
    end
  end
end
require 'airrecord'
require 'yaml'
require 'kramdown'
require 'dotenv'

Dotenv.load
SITE_SETTINGS = YAML.load_file("#{__dir__}/_config.yml")
AIRTABLE_BASE = SITE_SETTINGS['airtable_base_id']
ACCESS_TOKEN = ENV['AIRTABLE_ACCESS_TOKEN'] # set this in your .env

Airrecord.api_key = ACCESS_TOKEN

def underscore(str)
  str.downcase.gsub(/\s+/, '_')
end

def to_html(text)
  Kramdown::Document.new(text.gsub("\n", "\n\n")).to_html.gsub(/<a href="h/, '<a target="_blank" href="h')
end

def process(key, value)
  if key.downcase == 'details' && value.is_a?(Array)
    value = value.join("\n")
  end
  if %w(summary introduction details).include?(key.downcase) && value.is_a?(String)
    value = to_html(value)
  end
  if value.is_a?(String)
    value = value.strip
  end
  value
end

['Use Case', 'Dataset', 'Data Gap', 'Data Gap Details', 'Data Gap Type', 'Sectors', 'Data Modalities'].each do |table_name|
  table = Class.new(Airrecord::Table) do
    self.table_name = table_name
    self.base_key = AIRTABLE_BASE
  end
  records = {}
  table.all.sort_by { |record|
    record.fields['Name'] || record.id
  }.each { |record|
    fields = { 'airtable_id' => record.id }
    fields.merge!(record.fields)
    fields = fields.map{|k,v| [underscore(k), process(k, v)] }.to_h
    records[record.id] = fields
  }
  filename = "data_gaps_#{underscore(table_name)}"
  filename.sub!('data_gaps_data_gap', 'data_gaps')
  filename += 's' unless filename.end_with?('s')
  File.write("_data/#{filename}.yaml", YAML.dump(records))
end

data_gaps = YAML.load(File.read("_data/data_gaps.yaml"))
use_cases = YAML.load(File.read("_data/data_gaps_use_cases.yaml"))
datasets = YAML.load(File.read("_data/data_gaps_datasets.yaml"))

datasets.keys.each do |id|
  next unless datasets[id]['data_gaps']
  datasets[id]['data_gaps'] = datasets[id]['data_gaps'].sort_by { |gap_id|
    underscore(use_cases[data_gaps[gap_id]['use_case'][0]]['name']) rescue ''
  }.select{|s| s.length > 0}
end

use_cases.keys.each do |id|
  next unless use_cases[id]['data_gaps']
  use_cases[id]['data_gaps'] = use_cases[id]['data_gaps'].sort_by { |gap_id|
    underscore(datasets[data_gaps[gap_id]['dataset'][0]]['name']) rescue ''
  }.select{|s| s.length > 0}
end

File.write("_data/data_gaps_datasets.yaml", YAML.dump(datasets))
File.write("_data/data_gaps_use_cases.yaml", YAML.dump(use_cases))

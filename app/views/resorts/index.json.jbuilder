json.array!(@resorts) do |resort|
  json.extract! resort, :id, :name
  json.url resort_url(resort, format: :json)
end

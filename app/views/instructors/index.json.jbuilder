json.array!(@instructors) do |instructor|
  json.extract! instructor, :id, :first_name, :last_name, :certification, :phone_number, :sport, :bio, :intro, :status
  json.url instructor_url(instructor, format: :json)
end

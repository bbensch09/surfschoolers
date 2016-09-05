json.array!(@transactions) do |transaction|
  json.extract! transaction, :id, :lesson_id, :requester_id, :base_amount, :tip_amount, :final_amount
  json.url transaction_url(transaction, format: :json)
end

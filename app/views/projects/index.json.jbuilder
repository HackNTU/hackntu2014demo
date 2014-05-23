json.array!(@projects) do |project|
  json.extract! project, :id, :title, :description, :user_id
  json.url project_url(project, format: :json)
end

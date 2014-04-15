json.array! @questions do |q|
  json.id q.id
  json.title q.title
  json.group q.group.present?
  json.public q.public
  json.creator q.account.username
  json.tags q.tags :name
  json.created q.created_at
  json.updated q.updated_at
end
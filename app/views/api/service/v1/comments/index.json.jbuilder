json.array! @comments do |c|
  json.id         c.id
  json.comment    c.content
  json.commenter  c.account.username
  json.submitted  c.created_at
end
json.id           @answer.id
json.content      @answer.content
json.technician   @answer.account.username
json.submitted    @answer.created_at

json.comments @answer.comments.to_a.reverse! do |c|
  json.id         c.id
  json.comment    c.content
  json.commenter  c.account.username
  json.submitted  c.created_at
end
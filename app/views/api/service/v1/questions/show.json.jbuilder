json.id           @question.id
json.title        @question.title
json.content      @question.content
json.group        @question.group.present?
json.public       @question.public
json.author       @question.account.username
json.tags         @question.tags, :id, :name
json.submitted    @question.created_at

json.comments @question.comments.to_a.reverse! do |c|
  json.id         c.id
  json.comment    c.content
  json.commenter  c.account.username
  json.submitted  c.created_at
end

json.answers @question.answers.to_a.reverse! do |s|
  json.id           s.id
  json.content      s.content
  json.technician   s.account.username
  json.submitted    s.created_at

  json.comments s.comments.to_a.reverse! do |c|
    json.id         c.id
    json.comment    c.content
    json.commenter  c.account.username
    json.submitted  c.created_at
  end
end
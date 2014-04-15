json.id         @comment.id
json.comment    @comment.content
json.commenter  @comment.account.username
json.submitted  @comment.created_at
json.id @account.id
json.first_name @account.user.first_name
json.last_name @account.user.last_name
json.email @account.user.email
json.username @account.username
json.role @account.role
json.bio @account.bio
json.avatar @account.avatar
json.groups @account.groups, :name, :code, :description
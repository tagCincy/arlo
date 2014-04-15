json.id @group.id
json.name @group.name
json.code @group.code
json.description @group.description

json.accounts @group.accounts do |a|
  json.id a.id
  json.username a.username
  json.first_name a.user.first_name
  json.last_name a.user.last_name
  json.email a.user.email
  json.role a.role
end
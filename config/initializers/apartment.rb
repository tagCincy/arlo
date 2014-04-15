# require 'apartment/elevators/subdomain'
#
# Apartment.configure do |config|
#
#   config.excluded_models = ['User', 'Account', 'Group', 'Question', 'Answer', 'Comment', 'Tag', 'Membership', 'QuestionTag']
#   config.use_schemas = true
#   config.tenant_names = lambda{ Group.pluck :code }
# end
#
# Rails.application.config.middleware.use 'Apartment::Elevators::Subdomain'

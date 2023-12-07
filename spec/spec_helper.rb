require 'simplecov'

SimpleCov.start 'rails' do
  # Add any additional configuration here
  add_filter 'app/jobs/'
  add_filter 'app/mailers/'
  add_filter 'app/channels/'
end
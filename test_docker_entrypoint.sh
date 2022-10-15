set -e

echo "Environment: $RAILS_ENV"

# install missing gems
bundle check || bundle install --jobs 20 --retry 5

rails db:create RAILS_ENV=test
rails db:migrate RAILS_ENV=test

# run passed commands
bundle exec ${@}

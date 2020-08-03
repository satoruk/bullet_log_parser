# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gemspec

group :development do
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-doc'
  gem 'pry-stack_explorer'
end

group :development, :test do
  gem 'rake'
  gem 'reek'
  gem 'rspec'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
end

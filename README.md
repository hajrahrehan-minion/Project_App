# Project App

A small Rails app for keeping track of Projects with a has_many association to Tasks. All Tasks belong_to a Project. Contains Rspec files for both models and requests. Authorization added using rails native authentication. 
Built as a learning project.

## What it does

- Log in with email and password (with password reset)
- Create, edit and delete projects
- Add tasks to each project

## Tech

Ruby 3.4.4 · Rails 8.1 · SQLite · RSpec

## Getting started

    git clone https://github.com/hajrahrehan-minion/Project_App.git
    cd Project_App
    bundle install
    bin/rails db:prepare

There's no sign-up page yet, so create your first user from the console:

    bin/rails console
    User.create!(email_address: "you@example.com", password: "password")

Then start the server and log in at http://localhost:3000:

    bin/dev

## Running the tests

    bundle exec rspec

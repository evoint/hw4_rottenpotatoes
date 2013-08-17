
# Add a declarative step here for populating the DB with movies.

Given /^the following movies exist:$/ do |table|
  # table is a Cucumber::Ast::Table
  # each returned element will be a hash whose key is the table header.
  # add that movie to the database here.
  table.hashes.each do |movie|
  	Movie.create!(movie)
  end  
end

Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end
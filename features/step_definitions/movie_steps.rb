
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
  # express the regexp above with the code you wish you had
  page.body.should match(/#{arg1}.*Director.*#{arg2}/m)
end

When /^I dump.* the response$/ do
	puts body
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  page.body.should match(/#{e1}.*#{e2}/m)
  
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  #debugger
  rating_list.split(', ').each do |rating|
    if uncheck == 'un'
      uncheck("ratings_#{rating}")
    else
      check("ratings_#{rating}")
    end
  end
end

Given /^I check all the ratings$/ do
  # express the regexp above with the code you wish you had
  step "I check the following ratings: G, PG, PG-13, R"
end

Then /^I should see all of the movies$/ do
  # express the regexp above with the code you wish you had
  value = Movie.all.count
  #rows = page.all("#movies tr").length
  rows = page.all("table#movies tbody tr").length
  rows.should == value
end

Given /^I uncheck all ratings$/ do
  # express the regexp above with the code you wish you had
  step "I uncheck the following ratings: G, PG, PG-13, R"
end

Then /^I should see no movies$/ do
  # express the regexp above with the code you wish you had
  rows = page.all("table#movies tbody tr").length
  rows.should == 0
end
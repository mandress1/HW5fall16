# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 
monthNums = {"Jan" => 1, "Feb" => 2, "Mar" => 3, "Apr" => 4, "May" => 5, "Jun" => 6, "Jul" => 7, "Aug" => 8, "Sep" => 9, "Oct" => 10, "Nov" => 11, "Dec" => 12}

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^\"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database."
    Movie.create!(movie)
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  ratings = arg1.scan(/[^, ]+/)
  
  all('input[type=checkbox]').each do |cBox|
    if ratings.include?(cBox[:id][8..-1])
      check(cBox[:id])
    else
      uncheck(cBox[:id])
    end
  end
  
  click_button("ratings_submit")
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
  ratings = arg1.scan(/[^, ]+/)
  all('td').each do |el|
    if el[:class] == "rating"
      expect(ratings).to include(el.text)
    end
  end
end

Then /^I should see all of the movies$/ do
  seen = {}
  Movie.all.each do |mov|
    seen[mov.title] = false
  end
  
  all('td').each do |td|
    if td[:class] == "title"
      seen[td.text] = true
    end
  end
  
  seen.each do |title, hasSeen|
    expect(hasSeen).to eq(true)
  end
end

When /^I have opted to sort the movies by "(.*?)"$/ do |arg1|
  id = arg1.gsub(' ', '_')+"_header"
  puts "#{id}"
  click_link(id)
end

Then /^I should see "(.*?)" before "(.*?)"$/ do |arg1, arg2|
  movies=[]
  all('td').each do |td|
    if td[:class] == "title"
      movies.push(td.text)
    end
  end
  ind1 = movies.index(arg1)
  ind2 = movies.index(arg2)
  puts "1: #{ind1} 2:#{ind2}"
  expect(arg1).not_to be(nil)
  expect(arg2).not_to be(nil)
  expect(ind1 < ind2).to be(true)
end
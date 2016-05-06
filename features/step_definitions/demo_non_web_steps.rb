Given(/^a cucumber that is (\d+) cm long$/) do |length|
  @cucumber = { color: 'green', length: length.to_i }
end

When(/^I (?:cut|chop) (?:it|the cucumber) in (?:halves|half|two)$/) do
  @chopped_cucumbers = [
    { color: @cucumber[:color], length: @cucumber[:length] / 2 },
    { color: @cucumber[:color], length: @cucumber[:length] / 2 }
  ]
end

Then(/^I have two cucumbers$/) do
  expect(@chopped_cucumbers.length).to eq(2)
end

Then(/^both are (\d+) cm long$/) do |length|
  @chopped_cucumbers.each do |cuke|
    expect(cuke[:length]).to eq(length.to_i)
  end
end

# We use cucumber's AfterStep hook to insert our pause between pages if
# one was set
AfterStep do
  sleep((ENV['PAUSE'] || 0).to_i)
end

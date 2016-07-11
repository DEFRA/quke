# We use cucumber's AfterStep hook to insert our pause between pages if
# one was set
AfterStep do
  sleep($config.pause)
end

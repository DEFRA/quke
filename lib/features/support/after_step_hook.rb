require 'quke/configuration'

# We use cucumber's AfterStep hook to insert our pause between pages if
# one was set
AfterStep do
  sleep(Quke::Quke.config.pause)
end

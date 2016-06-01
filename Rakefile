desc 'Runs the poltergeist task as default'
task default: %w(poltergeist)

desc 'Run using Poltergeist headless browser'
task :poltergeist do
  pause = ENV['PAUSE'].to_i ||= 0
  sh %( PAUSE=#{pause} bundle exec cucumber )
end

desc 'Run using Firefox browser (add PAUSE=1 for 1 sec pause between pages)'
task :firefox do
  pause = ENV['PAUSE'].to_i ||= 0
  sh %( DRIVER=firefox PAUSE=#{pause} bundle exec cucumber )
end

desc 'Run using Chrome browser (add PAUSE=1 to for sec pause between pages)'
task :chrome do
  pause = ENV['PAUSE'].to_i ||= 0
  sh %( DRIVER=chrome PAUSE=#{pause} bundle exec cucumber )
end

desc 'Run the Quke demo web app (use for reference or confirming Quke works)'
task :run do
  sh %( bundle exec ruby quke_demo_app/app.rb )
end

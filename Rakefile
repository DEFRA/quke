desc 'Runs the phantomjs task as default'
task default: %w(phantomjs)

desc 'Run using Phantomjs headless browser /
  (add PAUSE=1 for 1 sec pause between pages)'
task :phantomjs do
  pause = ENV['PAUSE'].to_i ||= 0
  sh %( PAUSE=#{pause} bundle exec cucumber )
end

desc 'Run using Firefox browser (add PAUSE=1 for 1 sec pause between pages)'
task :firefox do
  pause = ENV['PAUSE'].to_i ||= 0
  sh %( DRIVER=firefox PAUSE=#{pause} bundle exec cucumber )
end

desc 'Run using Chrome browser (add PAUSE=1 for 1 sec pause between pages)'
task :chrome do
  pause = ENV['PAUSE'].to_i ||= 0
  sh %( DRIVER=chrome PAUSE=#{pause} bundle exec cucumber )
end

desc 'Run using Browserstack (add PAUSE=1 for 1 sec pause between pages)'
task :browserstack do
  pause = ENV['PAUSE'].to_i ||= 0
  sh %( DRIVER=browserstack PAUSE=#{pause} bundle exec cucumber )
end

desc 'Run the Quke demo web app (use for reference or confirming Quke works)'
task :run do
  if Gem::Specification.find_all_by_name('rerun').any?
    sh %( rerun --ignore 'features/' quke_demo_app/app.rb )
  else
    sh %( bundle exec ruby quke_demo_app/app.rb )
  end
end

desc 'Check Quke example tests are working by running them against the demo app'
task :check_quke do
  sh %( bundle exec cucumber -p quke)
end

desc 'Check Quke browserstack tests are working'
task :check_browserstack do
  sh %( DRIVER=browserstack bundle exec cucumber -p quke_browserstack)
end

desc 'Delete all Capybara saved pages in the tmp directory'
task :clean do
  File.delete(*Dir.glob('tmp/capybara-*.html'))
end

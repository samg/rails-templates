# from Sam Goldstein

# Lock this application to the current gems (by unpacking them into vendor/rails)
  rake 'rails:freeze:gems'

# Delete unnecessary files
  run "rm README"
  run "rm public/index.html"
  run "rm public/favicon.ico"
  run "rm public/robots.txt"
  run "rm -f public/javascripts/*"

# Download JQuery
  run "curl -L http://jqueryjs.googlecode.com/files/jquery-1.2.6.min.js > public/javascripts/jquery.js"
  run "curl -L http://jqueryjs.googlecode.com/svn/trunk/plugins/form/jquery.form.js > public/javascripts/jquery.form.js"

# Set up git repository
  git :init
  git :add => '.'
  
# Copy database.yml for distribution use
  run "cp config/database.yml config/database.yml.example"
  
# Set up .gitignore files
  run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
  run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}
  file '.gitignore', <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
*.swp
END

# Install submoduled plugins
# Install all gems
  gem 'thoughtbot-factory_girl', :lib => 'factory_girl', :source => 'http://gems.github.com'
  gem 'haml'
  gem "thoughtbot-clearance", :lib => 'clearance',
    :source  => 'http://gems.github.com', :version => '>= 0.6.4'
  gem 'webrat', :version => '>= 0.4.4'
  gem 'cucumber', :version => '>= 0.3.0'
  gem 'thoughtbot-factory_girl',
    :lib     => 'factory_girl',
    :source  => "http://gems.github.com", 
    :version => '>= 1.2.1'
  rake('gems:install', :sudo => true)
  rake('gems:unpack')


  generate('rspec')
  generate('clearance')
  generate('cucumber')
  generate('clearance_features', '--force')
  run 'haml --rails .'
  rake('db:migrate')

# Commit all work so far to the repository
  git :add => '.'
  git :commit => "-a -m 'Initial commit'"

# Success!
  puts "SUCCESS!"

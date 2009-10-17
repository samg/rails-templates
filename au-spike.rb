# from Sam Goldstein

# Delete unnecessary files
  run "rm README"
  run "rm public/index.html"
  run "rm public/favicon.ico"
  run "rm public/robots.txt"
  run "rm -f public/javascripts/*"

# Download JQuery
  run "curl -L http://jqueryjs.googlecode.com/files/jquery-1.3.2.min.js  > public/javascripts/jquery.js"
# Download resizing textareas
  run "curl -L http://gist.github.com/117849.txt > public/javascripts/form_enhancements.js"
# Download 960.gs
#  run "curl -L  http://github.com/nathansmith/960-grid-system/raw/cba77b87b377e7259dd4de3b15483087f081dfea/code/css/960.css > public/stylesheets/960.css"
#  run "curl -L  http://github.com/nathansmith/960-grid-system/raw/cba77b87b377e7259dd4de3b15483087f081dfea/code/css/reset.css > public/stylesheets/reset.css"
#  run "curl -L  http://github.com/nathansmith/960-grid-system/raw/cba77b87b377e7259dd4de3b15483087f081dfea/code/css/text.css > public/stylesheets/text.css"

# add some style
  file 'public/stylesheets/style.css', <<-CSS
#flash div{padding:5px 5px;margin:5px 0;}
#flash .notice, #flash .success{background:#cfc;}
#flash .failure, #flash .error{background:#fcc;}
CSS


# Set up git repository
  git :init

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
  gem 'haml'
  gem 'thoughtbot-factory_girl',
    :lib     => 'factory_girl',
    :source  => "http://gems.github.com", 
    :version => '>= 1.2.1'
  rake('gems:install', :sudo => true)
  rake('gems:unpack')


  generate('rspec')

  run 'haml --rails .'
  rake('db:create:all')
  rake('db:migrate')

  # add a basic layout
  file 'app/views/layouts/application.html.haml', <<-HAML
!!! Strict
%html{html_attrs('en-en')}
  %head
    %meta{'http-equiv' => "content-type", :content => "text/html; charset=utf-8"}
    %title Title
    = stylesheet_link_tag "style"
    = javascript_include_tag "jquery", "jquery.form", "form_enhancements"
  %body
    #container.container_12
      #header
        %h1 Header
      #wrapper
        #flash
          - flash.each do |kv|
            %div{:class => kv.first}= h(kv.last)
        #content= yield
HAML


# Commit all work so far to the repository
  git :add => '.'
  git :commit => "-a -m 'Initial commit'"

# Success!
  puts "SUCCESS!"

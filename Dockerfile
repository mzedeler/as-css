FROM europe-west3-docker.pkg.dev/fluid-axis-187614/docker/ruby-oci8:3.4.3-oci19_10-slim-bookworm-v5

RUN bundle init
RUN apt-get update && apt-get -y install gcc make git joe
RUN bundle add rails --version 8.0.2
WORKDIR /
RUN rails new --skip-asset-pipeline --skip-action-cable --skip-action-mailer --skip-hotwire as-css
WORKDIR /as-css
# //= link_tree ../fonts
RUN bundle add sprockets-rails --version 3.5.2
RUN bundle add tailwindcss-rails --version 3.3.1
RUN mkdir -p app/assets/config ; cat - > app/assets/config/manifest.js <<EOM
//= link_tree ../images
//= link_tree ../builds
//= link application.js
//= link application.css
EOM
RUN perl -pe 's/(require "rails.all")/$1\nrequire "sprockets\/railtie"/' -i config/application.rb
RUN bin/rails tailwindcss:install
RUN bin/rails generate controller people show
RUN bin/rails assets:precompile

# Data Gaps Explorer

## To run locally

* Install [Ruby](https://rubyinstaller.org/downloads/)
* Run `gem install bundler`
* Run `bundle install` (you may be missing some C libraries, try running `pacman -S mingw-w64-ucrt-x86_64-libxml2 mingw-w64-ucrt-x86_64-libxslt`)
* Run `bundle exec ruby download_data_gaps_data.rb`
* Run `bundle exec jekyll serve`
* Visit <http://localhost:4000> and view your data

## To deploy with GitHub Pages

## To adapt data

The data gaps visualization is based on Airtable data. For this repository, it's based on [this Airtable base](https://airtable.com/appY2hJvi0WWoFOPx/shremrztqdMIGGLkC).

To adapt it to your own use-case, you just need to:
- copy [the template base](https://airtable.com/appY2hJvi0WWoFOPx/shremrztqdMIGGLkC)
- update [`_config.yml`](./_config.yml) with the IDs of your new base and associated forms
- create a personal access token for your new base and update `.env` with `AIRTABLE_ACCESS_TOKEN=<token>`
- make changes to data in Airtable

Based on the Climate Change AI [data gaps page](https://www.climatechange.ai/dev/datagaps).
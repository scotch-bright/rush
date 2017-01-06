# Rush

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/rush`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rush'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rush

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rush. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

---

# rush
To make static sites super fast using ideas inspired by ROR

# The architecture

Below are the different classes and the role they will play. I am trying to stub out the details so that the classes can be made.

## PageMaker (Class)

### User Requirement Catered To
Almost all static sites will have certain areas like headers and footers that are common across many pages. A page is usually made up of a layout that is common to many different pages. Some pages might be different however. These page will need a different layout. These slightly different page/pages will have duplication of HTML/CSS/JS between them. To address all these problems and keep the code as DRY as possible the PageMaker object will assemble pages and return the HTML of the entire page based on the views, template and partials supplied.

### Single Responsibility
Getting the content from the different folders (layouts, views, partials) in the application and producing an HTML output to return to the browser as a string. This means assembling the pages from the different folders and also processing the ERB within the pages.

### Arguments For Initialization 
1. Application "config" settings object that will contain the folders which contain the "views", "layouts", "partials".

2. "data" object that contains all the data that may be stored in the "data" folder of the app.

### Public Interface
There will be a method that takes the GET request string in the form of "welcome", "articles" or "about_us". This methods name will be 'get_page_contents(page_path)'

### Testing Plan
Make "test_page_maker" folder inside the test folder. Make multiple apps inside with "views", "layouts", "partials" folders and test if the output is being created properly.

---

## Application

### User Requirement Catered To
Making a static site. This will be the main class that holds all the config details etc. It will be used to orchestrate the functioning of the entire rack app. The user requirement is that of the entire project.

### Single Responsibility
Handling requests for the rack app. Routing requests appropriately making use of all the other classes.

### Arguments For Initialization 
1. The Config Struct that contains details as follows:

	Folder Locations:
		images folder
		data folder
		static resources folder
		css folder
		js folder
		views folder
		partials folder
		headers_folder
		errors folder
		layouts folder
		errors folder
	Application Level Settings (Boolean Flags):
		production?

### Public Interface
This will be the "call" method with an environment variable on the application object thus making it a rack app.

### Testing Plan
Need to figure this out.

---

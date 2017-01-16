module Rush

  ERROR_TITLE_MALFORMED_JSON = "Malformed JSON in Data Folder"
  ERROR_DESC_MALFORMED_JSON = "It seems that some of the JSON files you have in the data folder of your application have malformed JSON. You can try to correct this with the help of a tool like <a href='http://jsonlint.com/'>http://jsonlint.com/</a>. To learn more about what JSON is and how to write valid JSON, you can <a href='https://www.tutorialspoint.com/json/'>check this out.</a> If you do not need any of the JSON files in the data folder, you can simply delete them all and this error will go away."

  ERROR_TITLE_PAGE_NOT_FOUND = "Page File Not Found :: "
  ERROR_DESC_PAGE_NOT_FOUND = "A file representing this path was not found in the pages folder. For a page to be formed correctly a file with the same name as the path needs to be present in the pages folder of the application. For example, if you would like to have a page at http://yoursite.com/welcome , then you will need to have a file called 'welcome.html' in the pages folder. This page will just contain the BODY HTML of the welcome page. Nothing more. It will be combined with the layouts, partials etc automagically."

  ERROR_TITLE_PARTIAL_NOT_FOUND = "Partial File Not Found :: "
  ERROR_DESC_PARTIAL_NOT_FOUND = "A partial file was asked for that was not found in the partials folder. Partials can be used to reuse certain chunks of HTML across multiple pages. To use a partial, all you have to do is create a file called 'my_partial.html' and place it in the partials folder. Then, from any of your pages or layouts you can simply call 'render_partial \"my_partial\"'. This will drop the HTML from the file 'my_partial.html where ever you have made that call. Currently, you are seeing this error because there is a call to 'render_partial ...' but the partial file you have asked for is not found in the partials folder."

  ERROR_TITLE_LAYOUT_NOT_FOUND = "Layout File Asked For In The Page Not Found :: "
  ERROR_DESC_LAYOUT_NOT_FOUND = "It seems that the page is asking for a custom layout file via the first line comment. Rush is trying to find the layout file in the layouts folder but the file seems to be missing. Please check to see if the layout file is present in the layouts folder. If the first line with the comment is removed, Rush will try to use the default layout file 'application.html' which is hopefully in the layouts folder."

  ERROR_TITLE_STANDARD_LAYOUT_NOT_FOUND = "Layout File 'application.html' Not Found :: "
  ERROR_DESC_STANDARD_LAYOUT_NOT_FOUND = "It seems that the layout file 'application.html' which should be present in the layouts folder is missing. Because of this Rush is not sure what layout needs to be shown around the page. Please create a file called 'application.html' in the layouts folder. Also, make sure the file includes a call to 'render_page'. If not, Rush will not know where to put in your page's content."

  ERROR_TITLE_NO_CALL_TO_RENDER_PAGE = "'render_page' Not Called In Layout"
  ERROR_DESC_NO_CALL_TO_RENDER_PAGE = "It seems that layout file does not call 'render_page' anywhere in its content. This is confusing for Rush. Rush will not know where the contents of the page need to be placed. Please make a call to 'render_page' somewhere in the layout."

  ERROR_TITLE_GENERAL_RUBY_ERROR = "Something Went Wrong When Parsing Ruby"

  ERROR_TITLE_YAML_CONFIG_PARSE_ERROR = "Config File 'rush_config.yml' Could Not Be Parsed"
  ERROR_DESC_YAML_CONFIG_PARSE_ERROR = "It seems that the config file was not in a proper format. Even though the config file may seem to be plain english, it needs to be formatted in a specific way. The config file needs to be in valid YAML format. To learn more about YAML and how to write correct YAML, you can <a href='https://learn.getgrav.org/advanced/yaml'>go here.</a>"  

  CSS_SERVER_404_MESSAGE = "The CSS file asked for was not found (or it may be blank)."
  JS_SERVER_404_MESSAGE = "The JS file asked for was not found (or it may be blank)."

end

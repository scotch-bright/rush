require 'sass'

module Rush

  # == User Requirement Catered To
  # The purpose of the css server is to handle combining of the css files, converting scss to css and minifying the css files effortlessly. All the developer needs to do is enter in a reference to a special file called 'application.css'. This file will contain a combined and minfied version of all the CSS files in the CSS folder specified. One file can be asked for at a time. Also once the project is being compiled, the CSSServer is capable of minifying the CSS files as required.
  class CSSServer

    def initialize(config)
      @css_folder_path = config.css_folder
      @minify = config.minify_css == true ? true : false
    end

    # Method that is required to turn the class into a Rack app
    def call(env)
      request = Rack::Request.new(env)
      path = request.path

      # Removing the starting forward slash that comes with the path
      path = path.gsub("/css/", "")

      begin
        css_string = get_css_file(path)
        if css_string == ""
          ['404', {'Content-Type' => 'text/html'}, [Rush::CSS_SERVER_404_MESSAGE]]
        else
          ['200', {'Content-Type' => 'text/css'}, [css_string]]
        end
      rescue Exception => e
        ['500', {'Content-Type' => 'text/html'}, [e.message + " :: " + e.long_error_description]]
      end

    end

    # Gets the CSS file asked for. If an SCSS file is asked for, the SCSS will be converted to CSS and then served. This is done so that the developer can simply add a style sheet reference to a .scss file and will still get back a CSS file effortlessly. Additionally, if "application.css" is asked for then all the files in the CSS folder are combined in alphabetical order. If there are SCSS files they are tuned into CSS files.
    def get_css_file(css_file_name)

      # Setting up the output variable
      output = ""

      if is_file_scss?(css_file_name)
        # SCSS file handling
        begin
          output = Sass::Engine.new(get_css_file_contents(css_file_name), :syntax => :scss).render
        rescue
          raise Rush::RushError.new Rush::ERROR_TITLE_MALFORMED_SCSS_SCRIPT + css_file_name, Rush::ERROR_DESC_MALFORMED_SCSS_SCRIPT
        end
      else

        if css_file_name == "application.css"
          array_of_files = Rush::FileFetcher.array_of_file_paths(@css_folder_path)
          array_of_files.each_with_index do |file_path, i|
            file_name = Rush::FileFetcher.get_file_name_and_extension_from_path(file_path)
            output = output + get_css_file(file_name)
            output = output + "\n" if i < array_of_files.size - 1
          end
        else
          output = get_css_file_contents(css_file_name)
        end

      end

      # Minfy the CSS file if needed
      if @minify
        output = minify_css(output)
      end

      return output
    end

    private

    def get_css_file_contents(css_file_name)
      css_file_path = File.join(@css_folder_path, css_file_name)
      if Rush::FileFetcher.file_exists?(css_file_path)
        Rush::FileFetcher.get_file_contents css_file_path
      else
        ""
      end
    end

    def is_file_scss?(css_file_name)
      css_file_name.split(".")[1] == "scss" ? true : false
    end

    #--
    # Copyright (c) 2008 Ryan Grove <ryan@wonko.com>
    # All rights reserved.
    #
    # Redistribution and use in source and binary forms, with or without
    # modification, are permitted provided that the following conditions are met:
    #
    #   * Redistributions of source code must retain the above copyright notice,
    #     this list of conditions and the following disclaimer.
    #   * Redistributions in binary form must reproduce the above copyright notice,
    #     this list of conditions and the following disclaimer in the documentation
    #     and/or other materials provided with the distribution.
    #   * Neither the name of this project nor the names of its contributors may be
    #     used to endorse or promote products derived from this software without
    #     specific prior written permission.
    #
    # THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
    # AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    # IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    # DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
    # FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    # DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
    # SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    # CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
    # OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    # OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
    #++

    # = CSSMin
    #
    # Minifies CSS using a fast, safe routine adapted from Julien Lecomte's YUI
    # Compressor, which was in turn adapted from Isaac Schlueter's cssmin PHP
    # script.
    #
    # Author::    Ryan Grove (mailto:ryan@wonko.com)
    # Version::   1.0.3 (2013-03-14)
    # Copyright:: Copyright (c) 2008 Ryan Grove. All rights reserved.
    # License::   New BSD License (http://opensource.org/licenses/bsd-license.php)
    # Website::   http://github.com/rgrove/cssmin/
    #
    # == Example
    #
    #   require 'rubygems'
    #   require 'cssmin'
    #
    #   File.open('example.css', 'r') {|file| puts CSSMin.minify(file) }
    #
    def minify_css(input)
      css = input.is_a?(IO) ? input.read : input.dup.to_s

      # Remove comments.
      css = css.gsub(/\/\*[\s\S]*?\*\//, '')

      # Compress all runs of whitespace to a single space to make things easier
      # to work with.
      css = css.gsub(/\s+/, ' ')

      # Replace box model hacks with placeholders.
      css = css.gsub(/"\\"\}\\""/, '___BMH___')

      # Remove unnecessary spaces, but be careful not to turn "p :link {...}"
      # into "p:link{...}".
      css = css.gsub(/(?:^|\})[^\{:]+\s+:+[^\{]*\{/) do |match|
        match.gsub(':', '___PSEUDOCLASSCOLON___')
      end
      css = css.gsub(/\s+([!\{\};:>+\(\)\],])/, '\1')
      css = css.gsub('___PSEUDOCLASSCOLON___', ':')
      css = css.gsub(/([!\{\}:;>+\(\[,])\s+/, '\1')

      # Add missing semicolons.
      css = css.gsub(/([^;\}])\}/, '\1;}')

      # Replace 0(%, em, ex, px, in, cm, mm, pt, pc) with just 0.
      css = css.gsub(/([\s:])([+-]?0)(?:%|em|ex|px|in|cm|mm|pt|pc)/i, '\1\2')

      # Replace 0 0 0 0; with 0.
      css = css.gsub(/:(?:0 )+0;/, ':0;')

      # Replace background-position:0; with background-position:0 0;
      css = css.gsub('background-position:0;', 'background-position:0 0;')

      # Replace 0.6 with .6, but only when preceded by : or a space.
      css = css.gsub(/(:|\s)0+\.(\d+)/, '\1.\2')

      # Convert rgb color values to hex values.
      css = css.gsub(/rgb\s*\(\s*([0-9,\s]+)\s*\)/) do |match|
        '#' << $1.scan(/\d+/).map{|n| n.to_i.to_s(16).rjust(2, '0') }.join
      end

      # Compress color hex values, making sure not to touch values used in IE
      # filters, since they would break.
      css = css.gsub(/([^"'=\s])(\s?)\s*#([0-9a-f])\3([0-9a-f])\4([0-9a-f])\5/i, '\1\2#\3\4\5')

      # Remove empty rules.
      css = css.gsub(/[^\}]+\{;\}\n/, '')

      # Re-insert box model hacks.
      css = css.gsub('___BMH___', '"\"}\""')

      # Put the space back in for media queries
      css = css.gsub(/\band\(/, 'and (')

      # Prevent redundant semicolons.
      css = css.gsub(/;+\}/, '}')

      css.strip
    end

  end

end

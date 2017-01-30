module Rush

  class CSSMinifier

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
    def self.minify_this input
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

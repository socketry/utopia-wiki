# frozen_string_literal: true

# Copyright, 2020, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require "utopia/wiki/version"

require 'kramdown'
require 'utopia/localization'
require 'utopia/gallery'

module Utopia
	module Wiki
		SITE_ROOT = File.expand_path("../..", __dir__)
		PAGES_ROOT = File.expand_path("pages", SITE_ROOT)
		PUBLIC_ROOT = File.expand_path("public", SITE_ROOT)
		
		def self.call(builder, root = Dir.pwd, locales: nil)
			if UTOPIA.production?
				# Handle exceptions in production with a error page and send an email notification:
				builder.use Utopia::Exceptions::Handler
				builder.use Utopia::Exceptions::Mailer
			else
				# We want to propate exceptions up when running tests:
				builder.use Rack::ShowExceptions unless UTOPIA.testing?
			end
			
			public_root = File.expand_path("public", root)
			builder.use Utopia::Static, root: public_root
			
			builder.use Utopia::Static, root: PUBLIC_ROOT
			
			builder.use Utopia::Redirection::Rewrite, {
				'/' => '/index'
			}
			
			builder.use Utopia::Redirection::DirectoryIndex
			
			builder.use Utopia::Redirection::Errors, {
				404 => '/errors/file-not-found'
			}
			
			if locales
				builder.use Utopia::Localization,
					default_locale: locales.first,
					locales: locales
			end
			
			builder.use Utopia::Controller, root: PAGES_ROOT
			
			cache_root = File.expand_path("_gallery", root)
			
			builder.use Utopia::Content, root: PAGES_ROOT, namespaces: {
				'gallery' => Utopia::Gallery::Tags.new
			}
			
			builder.run lambda { |env| [404, {}, []] }
		end
	end
end

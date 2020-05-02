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

require 'utopia/path'
require 'trenni/reference'
require 'decode'

module Utopia
	module Wiki
		# Generates wiki pages from source code, including cross-referenced links and formatted comments.
		class Code
			# A code instance with canonical defaults for a wiki in the current directory.
			def self.wiki
				root = File.expand_path("wiki/pages")
				relative_path = ["source"]
				
				self.new(root, relative_path)
			end
			
			# Initialize the generator with the given root path to the wiki and the relative path to use within the wiki.
			# @param root [String] The file-system path to the root of the wiki.
			# @param relative_path [Utopia::Path] The relative path where the generated files should be placed.
			def initialize(root, relative_path)
				@root = root
				@relative_path = relative_path
				
				@path = Utopia::Path[@relative_path].to_absolute
				
				@index = Decode::Index.new
			end
			
			# The file-system path to the root of the wiki.
			attr :root
			
			# The relative path where the generated files should be placed.
			attr :relative_path
			
			# The source code index which is used for generating pages.
			attr :index
			
			# Update the index by loading and parsing the specified paths.
			# @param paths [Array(String)] The paths to load and parse.
			def update(paths)
				@index.update(paths)
			end
			
			# Generate the documentation files.
			def generate
				generate_index
				
				scopes = {}
				
				@index.trie.each do |path, node|
					if symbols = node.values
						symbol = best(symbols)
						
						if symbol.container?
							$stderr.puts "Generating page for #{symbol.qualified_name}"
							generate_page(symbol, node)
						end
					end
					
					true
				end
			end
			
			protected
			
			WARNING = ['', "<!-- This page is automatically generated. Regenerating this page will overwrite any changes! -->", '']
			
			def best(symbols)
				symbols.each do |symbol|
					if symbol.documentation
						return symbol
					end
				end
				
				return symbols.first
			end
			
			def linkify(text, symbol)
				return text unless symbol
				
				text&.gsub(/{(.*?)}/) do |match|
					reference = symbol.language.reference($1)
					
					if symbol = @index.lookup(reference, relative_to: symbol)&.first
						"[`#{symbol.short_form}`{:.language-ruby}](#{link_for(symbol)})"
					else
						"`#{$1}`"
					end
				end
			end
			
			# The path for the index markdown file.
			INDEX = "index.md"
			
			# Generate a file-system path to the given page.
			def path_for(page = nil)
				File.join(@root, @relative_path, *page, INDEX)
			end
			
			# Compute an HTML id for the given symbol.
			def id_for(symbol)
				symbol.qualified_name.gsub(/[^\w]/, '')
			end
			
			# Compute an HTML link to the given symbol.
			def link_for(symbol)
				path = symbol.lexical_path.map{|entry| entry.to_s.downcase}
				
				if symbol.container?
					return Trenni::Reference.new(@path + path + "index")
				else
					name = path.pop
					return Trenni::Reference.new(@path + path + "index", fragment: id_for(symbol))
				end
			end
			
			# Generate the documentation index file.
			def generate_index
				index_path = path_for # nothing
				
				FileUtils.mkpath(File.dirname(index_path))
				
				File.open(index_path, "w") do |io|
					io.puts "# Index"
					io.puts WARNING
					
					@index.trie.each do |path, node|
						if symbols = node.values
							symbol = best(symbols)
							
							indentation = "\t" * (path.size - 1)
							
							if documentation = symbol.documentation
								io.puts "#{indentation}- [`#{symbol.long_form}`{:.language-ruby}](#{link_for(symbol)})"
								io.puts "#{indentation}  #{linkify(documentation.description.first, symbol)}"
							elsif symbol.container?
								io.puts "#{indentation}- `#{symbol.long_form}`{:.language-ruby}"
							else
								# Don't descend any further:
								throw :skip
							end
						end
					end
				end
			end
			
			# Generate the documentation for a specific symbol.
			def generate_definition(io, path, symbol)
				if documentation = symbol.documentation
					io.puts
					io.puts "\#\#\# `#{symbol.long_form}`{:.language-ruby} {\##{id_for(symbol)}}"
					io.puts
					
					documentation.description do |line|
						io.puts linkify(line, symbol)
					end
					
					parameters = documentation.parameters.to_a
					
					if parameters.any?
						io.puts
						io.puts "\#\#\#\# Parameters"
						io.puts
						parameters.each do |parameter|
							io.puts "`#{parameter[:name]}` `#{parameter[:type]}`{:.language-ruby}"
							io.puts ": #{linkify(parameter[:details], symbol)}"
							io.puts
						end
					end
				end
			end
			
			# Generate a page for a specific symbol and all it's children.
			def generate_page(symbol, node)
				path = path_for(
					symbol.lexical_path.map{|entry| entry.to_s.downcase}
				)
				
				FileUtils.mkpath(File.dirname(path))
				
				File.open(path, "w") do |io|
					io.puts "\# `#{symbol.qualified_name}`{:.language-ruby}"
					io.puts WARNING
					
					if documentation = symbol.documentation
						io.puts
						documentation.description do |line|
							io.puts linkify(line, symbol)
						end
					end
					
					nested = node.children.map{|name, child| best(child.values)}.select{|symbol| symbol.container?}
					
					if nested.any?
						io.puts
						io.puts "\#\# Nested"
						nested.each do |symbol|
							io.puts "- [#{symbol.qualified_name}](#{link_for(symbol)})"
						end
					end
					
					generate_definitions(io, path, node)
				end
			end
			
			def generate_definitions(io, path, node)
				printed = false
				
				node.children.each do |name, child|
					child.values.each do |symbol|
						if symbol.documentation and !symbol.container?
							unless printed
								io.puts
								io.puts "\#\# Definitions"
								printed = true
							end
							
							generate_definition(io, path, symbol)
						end
					end
				end
			end
		end
	end
end

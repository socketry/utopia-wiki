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
						symbols.each do |symbol|
							if [:module, :class].include?(symbol.kind)
								scopes[path] ||= symbol.key
								
								$stderr.puts "Generating page for #{symbol.qualified_name}"
								generate_page(symbol, node)
							end
						end
					end
					
					true
				end
			end
			
			protected
			
			INDEX = "index.md"
			
			def path_for(page = nil)
				File.join(@root, @relative_path, *page, INDEX)
			end
			
			def link_for(symbol)
				path = symbol.lexical_path.map{|entry| entry.to_s.downcase}
				
				return Trenni::Reference.new(@path + path + "index", fragment: symbol.qualified_name)
			end
			
			def generate_index
				File.open(path_for, "w") do |io|
					io.puts "# Symbols"
					io.puts
					
					@index.symbols.each do |name, symbol|
						io.puts "- [`#{symbol.qualified_name}`](#{link_for(symbol)})"
					end
				end
			end
			
			def generate_definition(io, path, symbol)
				if documentation = symbol.documentation
					io.puts
					io.puts "\#\# `#{symbol.long_form}`{:.language-ruby}"
					io.puts
					
					documentation.description do |line|
						io.puts line
					end
					
					parameters = documentation.parameters.to_a
					
					if parameters.any?
						io.puts
						parameters.each do |parameter|
							io.puts "`#{parameter[:name]}`"
							io.puts ": #{parameter[:details]}"
							io.puts
						end
					end
				end
			end
			
			def generate_page(symbol, node)
				path = path_for(
					symbol.lexical_path.map{|entry| entry.to_s.downcase}
				)
				
				FileUtils.mkpath(File.dirname(path))
				
				File.open(path, "w") do |io|
					io.puts "\# `#{symbol.qualified_name}`"
					
					if node.children.any?
						io.puts
						io.puts "\#\# Nested"
						node.children.each do |name, child|
							if symbol = child.values.find{|symbol| symbol.kind == :class || symbol.kind == :module}
								io.puts "- [#{symbol.qualified_name}](#{symbol.name.downcase}/)"
							end
						end
					end
					
					node.children.each do |name, child|
						child.values.each do |symbol|
							generate_definition(io, path, symbol)
						end
					end
				end
			end
		end
	end
end

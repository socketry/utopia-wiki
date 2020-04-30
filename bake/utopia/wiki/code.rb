
require 'decode'

def index
	@paths = Dir.glob("lib/utopia/**/*.rb")
	@output_path = File.expand_path("wiki/pages")
	@relative_path = ["source"]
	
	index = Decode::Index.new
	index.update(@paths)
	
	index.symbols.each do |key, symbol|
		puts "#{key} #{symbol.kind}"
	
		if comments = symbol.comments
			comments.each do |line|
				puts line
			end
		end
	end
	
	scopes = {}
	
	index.trie.each do |path, node|
		if symbols = node.values
			symbols.each do |symbol|
				if [:module, :class].include?(symbol.kind)
					scopes[path] ||= symbol.key
					
					$stderr.puts "Generatig page for #{symbol.qualified_name}"
					generate_page(symbol, node)
				end
			end
		end
		
		true
	end
end

private

def generate_definition(io, path, symbol)
	if documentation = symbol.documentation
		io.puts
		io.puts "\#\# `#{symbol.name}`"
		io.puts
		
		documentation.description do |line|
			io.puts line
		end
	end
end

def generate_page(symbol, node)
	normalized_path = symbol.lexical_path.map{|entry| entry.to_s.downcase}
	path = File.join(@output_path, @relative_path, normalized_path, "index.md")
	
	FileUtils.mkpath(File.dirname(path))
	
	File.open(path, "w") do |io|
		io.puts "\# `#{symbol.qualified_name}`"
		
		if node.children.any?
			io.puts
			node.children.each do |name, child|
				if symbol = child.values.find{|symbol| symbol.kind == :class || symbol.kind == :module}
					io.puts "- [#{symbol.name}](#{symbol.name.downcase}/)"
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
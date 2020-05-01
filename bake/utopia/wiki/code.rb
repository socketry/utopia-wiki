
require 'utopia/wiki/code'

def generate
	paths = Dir.glob("lib/utopia/**/*.rb")
	output_path = File.expand_path("wiki/pages")
	relative_path = ["source"]
	
	code = Utopia::Wiki::Code.new(output_path, relative_path)
	
	code.update(paths)
	
	code.generate
end

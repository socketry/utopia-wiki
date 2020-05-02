
require 'utopia/wiki/code'

def generate
	paths = Dir.glob("lib/**/*.rb")
	output_path = File.expand_path("wiki/pages")
	relative_path = ["source"]
	
	code = Utopia::Wiki::Code.new(output_path, relative_path)
	
	code.update(paths)
	
	bundler = Bundler.load
	
	dependencies = bundler.dependencies.select do |dependency|
		dependency.groups.include?(:documentation)
	end
	
	dependencies.each do |dependency|
		if spec = Gem.loaded_specs[dependency.name]
			if path = spec.full_gem_path and File.directory?(path)
				lib_path = File.join(path, "lib")
				
				if File.directory?(lib_path)
					paths = Dir.glob(File.expand_path("**/*.rb", lib_path))
					code.update(paths)
				end
			end
		end
	end
	
	code.generate
end

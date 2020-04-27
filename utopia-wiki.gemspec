require_relative 'lib/utopia/wiki/version'

Gem::Specification.new do |spec|
	spec.name = "utopia-wiki"
	spec.version = Utopia::Wiki::VERSION
	spec.authors = ["Samuel Williams"]
	spec.email = ["samuel.williams@oriontransfer.co.nz"]
	
	spec.summary = "A simple wiki for Utopia."
	spec.homepage = "https://github.com/socketry/utopia-wiki"
	spec.license = "MIT"
	
	spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
		`git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
	end
	
	spec.require_paths = ["lib"]
	
	spec.add_dependency "utopia"
	spec.add_dependency "utopia-gallery"
	
	spec.add_dependency "kramdown"
	spec.add_dependency "kramdown-parser-gfm"
	
	spec.add_dependency "bake"
	spec.add_dependency "rackula"
	spec.add_dependency "falcon"
	
	spec.add_development_dependency "bake-bundler"
end

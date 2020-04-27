
# Server the wiki locally.
def serve
	system("bundle", "exec", "falcon", "serve")
end

def static(output_path: "static")
	require 'rackula/command'
	
	public_path = File.expand_path("../../public", __dir__)
	
	Rackula::Command::Top["generate", "--force", "--public", public_path, "--output-path", output_path].call
end

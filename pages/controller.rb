# frozen_string_literal: true

prepend Actions

ROOT = File.expand_path("pages")
LINKS = Utopia::Content::Links.new(ROOT, extension: ".md")

def index_path(locale)
	if locale
		"index.#{locale}.md"
	else
		"index.md"
	end
end

on '**' do |request, path|
	@full_path = URI_PATH + path
	@page_path = path.components[0..-2]
	
	@root = ROOT
	@links = LINKS
	@page_root = File.join(@root, @page_path)
	
	@localization = Utopia::Localization[request]
	@relative_page_file = File.join(@page_path, index_path(@localization.current_locale))
	@page_file = File.join(@root, @relative_page_file)
	
	if last_path_component = @page_path.last
		@title = Trenni::Strings.to_title(last_path_component)
	else
		@title = "Wiki"
	end
end

def exists?(locale: @localization.current_locale)
	relative_page_file = File.join(@page_path, index_path(locale))
	page_file = File.join(@root, relative_page_file)
	
	if File.exist?(page_file)
		return page_file
	end
end

def read_contents
	if path = (exists? || exists?(locale: nil))
		File.read(path)
	else
		"\# #{@title}\n\n" +
		"This page is empty."
	end
end

on '**/edit' do |request, path|
	if request.post?
		FileUtils.mkdir_p File.dirname(@page_file)
		
		# Get the content and normalize newlines:
		content = request.params['content'].gsub /\r\n?/, "\n"
		File.write(@page_file, content)
		
		# Redirect relative to controller.
		goto! Utopia::Path[@page_path] + "index"
	else
		@content = read_contents
	end
	
	path.components = ["edit"]
end

on '**/index' do |request, path|
	if exists?
		@content = read_contents
		path.components = ["show"]
	else
		path.components = ["create"]
	end
end

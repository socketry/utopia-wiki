# Index

<!-- This page is automatically generated. Regenerating this page will overwrite any changes! -->

- `module Utopia`{:.language-ruby}
	- [`module Wiki`{:.language-ruby}](/source/utopia/wiki/index)
	  A markdown-based wiki web application.
		- [`SITE_ROOT = File.expand_path("../..", __dir__)`{:.language-ruby}](/source/utopia/wiki/index#UtopiaWikiSITE_ROOT)
		  The root directory of the web application files.
		- [`PAGES_ROOT = File.expand_path("pages", SITE_ROOT)`{:.language-ruby}](/source/utopia/wiki/index#UtopiaWikiPAGES_ROOT)
		  The root directory for the utopia middleware.
		- [`PUBLIC_ROOT = File.expand_path("public", SITE_ROOT)`{:.language-ruby}](/source/utopia/wiki/index#UtopiaWikiPUBLIC_ROOT)
		  The root directory for static assets.
		- [`def self.call(builder, root = Dir.pwd, locales: nil)`{:.language-ruby}](/source/utopia/wiki/index#UtopiaWikicall)
		  Appends a wiki application to the rack builder.
		- [`class Code`{:.language-ruby}](/source/utopia/wiki/code/index)
		  Generates wiki pages from source code, including cross-referenced links and formatted comments.
			- [`def self.wiki`{:.language-ruby}](/source/utopia/wiki/code/index#UtopiaWikiCodewiki)
			  A code instance with canonical defaults for a wiki in the current directory.
			- [`def initialize(root, relative_path)`{:.language-ruby}](/source/utopia/wiki/code/index#UtopiaWikiCodeinitialize)
			  Initialize the generator with the given root path to the wiki and the relative path to use within the wiki.
			- [`attr :root`{:.language-ruby}](/source/utopia/wiki/code/index#UtopiaWikiCoderoot)
			  The file-system path to the root of the wiki.
			- [`attr :relative_path`{:.language-ruby}](/source/utopia/wiki/code/index#UtopiaWikiCoderelative_path)
			  The relative path where the generated files should be placed.
			- [`attr :index`{:.language-ruby}](/source/utopia/wiki/code/index#UtopiaWikiCodeindex)
			  The source code index which is used for generating pages.
			- [`def update(paths)`{:.language-ruby}](/source/utopia/wiki/code/index#UtopiaWikiCodeupdate)
			  Update the index by loading and parsing the specified paths.
			- [`def generate`{:.language-ruby}](/source/utopia/wiki/code/index#UtopiaWikiCodegenerate)
			  Generate the documentation files.
			- [`INDEX = "index.md"`{:.language-ruby}](/source/utopia/wiki/code/index#UtopiaWikiCodeINDEX)
			  The path for the index markdown file.
			- [`def path_for(page = nil)`{:.language-ruby}](/source/utopia/wiki/code/index#UtopiaWikiCodepath_for)
			  Generate a file-system path to the given page.
			- [`def id_for(symbol)`{:.language-ruby}](/source/utopia/wiki/code/index#UtopiaWikiCodeid_for)
			  Compute an HTML id for the given symbol.
			- [`def link_for(symbol)`{:.language-ruby}](/source/utopia/wiki/code/index#UtopiaWikiCodelink_for)
			  Compute an HTML link to the given symbol.
			- [`def generate_index`{:.language-ruby}](/source/utopia/wiki/code/index#UtopiaWikiCodegenerate_index)
			  Generate the documentation index file.
			- [`def generate_definition(io, path, symbol)`{:.language-ruby}](/source/utopia/wiki/code/index#UtopiaWikiCodegenerate_definition)
			  Generate the documentation for a specific symbol.
			- [`def generate_page(symbol, node)`{:.language-ruby}](/source/utopia/wiki/code/index#UtopiaWikiCodegenerate_page)
			  Generate a page for a specific symbol and all it's children.

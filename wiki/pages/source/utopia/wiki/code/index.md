# `::Utopia::Wiki::Code`{:.language-ruby}

<!-- This page is automatically generated. Regenerating this page will overwrite any changes! -->


Generates wiki pages from source code, including cross-referenced links and formatted comments.

## Definitions

### `def self.wiki`{:.language-ruby} {#UtopiaWikiCodewiki}

A code instance with canonical defaults for a wiki in the current directory.

### `def initialize(root, relative_path)`{:.language-ruby} {#UtopiaWikiCodeinitialize}

Initialize the generator with the given root path to the wiki and the relative path to use within the wiki.

#### Parameters

`root` `String`{:.language-ruby}
: The file-system path to the root of the wiki.

`relative_path` `Utopia::Path`{:.language-ruby}
: The relative path where the generated files should be placed.


### `attr :root`{:.language-ruby} {#UtopiaWikiCoderoot}

The file-system path to the root of the wiki.

### `attr :relative_path`{:.language-ruby} {#UtopiaWikiCoderelative_path}

The relative path where the generated files should be placed.

### `attr :index`{:.language-ruby} {#UtopiaWikiCodeindex}

The source code index which is used for generating pages.

### `def update(paths)`{:.language-ruby} {#UtopiaWikiCodeupdate}

Update the index by loading and parsing the specified paths.

#### Parameters

`paths` `Array(String)`{:.language-ruby}
: The paths to load and parse.


### `def generate`{:.language-ruby} {#UtopiaWikiCodegenerate}

Generate the documentation files.

### `INDEX = "index.md"`{:.language-ruby} {#UtopiaWikiCodeINDEX}

The path for the index markdown file.

### `def path_for(page = nil)`{:.language-ruby} {#UtopiaWikiCodepath_for}

Generate a file-system path to the given page.

### `def id_for(symbol)`{:.language-ruby} {#UtopiaWikiCodeid_for}

Compute an HTML id for the given symbol.

### `def link_for(symbol)`{:.language-ruby} {#UtopiaWikiCodelink_for}

Compute an HTML link to the given symbol.

### `def generate_index`{:.language-ruby} {#UtopiaWikiCodegenerate_index}

Generate the documentation index file.

### `def generate_definition(io, path, symbol)`{:.language-ruby} {#UtopiaWikiCodegenerate_definition}

Generate the documentation for a specific symbol.

### `def generate_page(symbol, node)`{:.language-ruby} {#UtopiaWikiCodegenerate_page}

Generate a page for a specific symbol and all it's children.

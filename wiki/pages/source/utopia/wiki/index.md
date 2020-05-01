# `::Utopia::Wiki`

## Nested
- [::Utopia::Wiki::Code](code/)

## `SITE_ROOT = File.expand_path("../..", __dir__)`{:.language-ruby}

The root directory of the web application files.

## `PAGES_ROOT = File.expand_path("pages", SITE_ROOT)`{:.language-ruby}

The root directory for the utopia middleware.

## `PUBLIC_ROOT = File.expand_path("public", SITE_ROOT)`{:.language-ruby}

The root directory for static assets.

## `def self.call(builder, root = Dir.pwd, locales: nil)`{:.language-ruby}

Appends a wiki application to the rack builder.

`locales`
: an array of locales to support, e.g. `['en', 'ja']`.


## `class Code`{:.language-ruby}

Generates wiki pages from source code, including cross-referenced links and formatted comments.

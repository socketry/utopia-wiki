# `::Utopia::Wiki`{:.language-ruby}

The Wiki module provides a `Rack` middleware and documentation generation tools. Using these tools allows you to easily and systematically build documentation wikis for Ruby gems and other kinds of projects.

To create a new wiki, use bake:

```bash
$ bake utopia:wiki:create
```

## Nested
- [::Utopia::Wiki::Code](/source/utopia/wiki/code/index)

## Symbols

### `SITE_ROOT = File.expand_path("../..", __dir__)`{:.language-ruby} {#UtopiaWikiSITE_ROOT}

The root directory of the web application files.

### `PAGES_ROOT = File.expand_path("pages", SITE_ROOT)`{:.language-ruby} {#UtopiaWikiPAGES_ROOT}

The root directory for the utopia middleware.

### `PUBLIC_ROOT = File.expand_path("public", SITE_ROOT)`{:.language-ruby} {#UtopiaWikiPUBLIC_ROOT}

The root directory for static assets.

### `def self.call(builder, root = Dir.pwd, locales: nil)`{:.language-ruby} {#UtopiaWikicall}

Appends a wiki application to the rack builder.

`locales`
: an array of locales to support, e.g. `['en', 'ja']`.


### `VERSION = "0.3.0"`{:.language-ruby} {#UtopiaWikiVERSION}

The current version of the gem.

# `::Utopia::Wiki`{:.language-ruby}

<!-- This page is automatically generated. Regenerating this page will overwrite any changes! -->


A markdown-based wiki web application.

The Wiki module provides a `Rack` middleware and documentation generation tools. Using these tools allows you to easily and systematically build documentation wikis for Ruby gems and other kinds of projects.

To create a new wiki, use bake:

```bash
$ bake utopia:wiki:create
```

See [`attr :root`{:.language-ruby}](/source/utopia/wiki/code/index#UtopiaWikiCoderoot) for the code generation part.

## Nested
- [::Utopia::Wiki::Code](/source/utopia/wiki/code/index)

## Definitions

### `SITE_ROOT = File.expand_path("../..", __dir__)`{:.language-ruby} {#UtopiaWikiSITE_ROOT}

The root directory of the web application files.

### `PAGES_ROOT = File.expand_path("pages", SITE_ROOT)`{:.language-ruby} {#UtopiaWikiPAGES_ROOT}

The root directory for the utopia middleware.

### `PUBLIC_ROOT = File.expand_path("public", SITE_ROOT)`{:.language-ruby} {#UtopiaWikiPUBLIC_ROOT}

The root directory for static assets.

### `def self.call(builder, root = Dir.pwd, locales: nil)`{:.language-ruby} {#UtopiaWikicall}

Appends a wiki application to the rack builder.

~~~ ruby
# In your `config.ru` file:

require 'utopia/setup'
UTOPIA ||= Utopia.setup

require 'utopia/wiki'
Utopia::Wiki.call(self)
~~~

#### Parameters

`locales` `Array(String)`{:.language-ruby}
: an array of locales to support, e.g. `['en', 'ja']`.


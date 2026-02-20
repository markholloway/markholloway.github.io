.PHONY: serve build clean all test ci

all: clean build serve

serve:
	go tool hugo server -D

test:
	cd ./content/blog/2025-12-28-gos-secret-weapon/examples && go test -v ./...

build:
	go tool hugo --minify --environment production
	# legacy mkdocs-created RSS feed
#	**Comment out reference to public and replace with docs for github compatability**
#	cp public/blog/index.xml public/feed_rss_created.xml
#	bunx pagefind --site public /or/ bunx pagefind --site docs
	cp docs/blog/index.xml docs/feed_rss_created.xml
	bunx pagefind --site docs

clean:
#	**Comment out public and replaces with docs for github compatability**
#	rm -rf public resources
	rm -rf docs resources

ci: test build

# **Local Development:**
# bash
# make  # Clean + build + serve (recommended)
# Or: make serve (serve only, without clean/build)

# **Production Build:**
# bash
# make build  # Hugo build + Pagefind indexing

# **Manual Commands:**
# - Hugo: `go tool hugo server -D` (dev) or
# go tool hugo --minify --environment production` (prod)
# Search: `bunx pagefind --site public` (after Hugo build)
# Clean: `make clean` (removes `public/` and `resources/`)


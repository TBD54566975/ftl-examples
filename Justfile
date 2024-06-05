# Start the FTL backend with hot-reloading
dev:
  ftl dev --recreate --allow-origins '*'

gen-mobile:
  ftl schema generate online-boutique/mobile/templates/ online-boutique/mobile/lib/api --watch=5s

gen-web:
  ftl schema generate online-boutique/web/templates/ online-boutique/web/src/api --watch=5s

# Start the example web frontend for online-boutique
web:
  cd online-boutique/web && npm install && npm run dev

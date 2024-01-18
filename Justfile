# Start the FTL backend with hot-reloading
dev:
  watchexec -r -e sql -- goreman -logtime=false -f Procfile.dev start

# Start the example web frontend for online-boutique
web:
  cd frontend/web && npm install && npm run dev

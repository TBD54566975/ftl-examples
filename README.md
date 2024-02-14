# FTL examples

This repository contains a few different example modules for FTL. The top-level
[go](./go) and [kotlin](./kotlin/) directories contain language-specific
examples, while the [online-boutique](./online-boutique/) directory contains a
full micro-services demo based on [GCP's
demo](https://github.com/GoogleCloudPlatform/microservices-demo) of the same
name.

## Running

In order to have all the tools you need to build and run the examples, follow one of these steps:

- Install [Hermit](https://cashapp.github.io/hermit/usage/get-started/) and related [shell_hooks](https://cashapp.github.io/hermit/usage/shell/).
- (or) Install and activate the Hermit environment manually: `. ./bin/activate-hermit`
- (or) Manually install Just, FTL, Flutter, Go, Goreman, Watchexec, etc. (not recommended)

## Online-boutique

The [online-boutique](./online-boutique) directory is designed to show how to
use FTL to build an online boutique backend with a mobile (Flutter) app and
React frontend.

### Preparation

After activating the Hermit environment (see above), change into the online-boutique directory:

```
cd online-boutique
```

To see a list of commands that can be run, run `just --list` in the root of the
project.

### Start FTL, code gen, and backend services with hot-reloading

```bash
just dev
```

### Start the React web app

```bash
just web
```

### Flutter app

Flutter is better run via an [IDE](https://docs.flutter.dev/get-started/editor?tab=vscode) like VSCode or Android Studio.

# FTL examples

## Introduction

This repo is designed to show how to use FTL to build an online boutique backend with a mobile (Flutter) app and React frontend.

## Running

* Install [Hermit](https://cashapp.github.io/hermit/usage/get-started/) and related [shell_hooks]([shell hooks](https://cashapp.github.io/hermit/usage/shell/)). 

>[NOTE] This will install [Just](https://github.com/casey/just) for you.

To see a list of commands that can be run, run `just --list` in the root of the project.

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

## Project Resources

| Resource                                   | Description                                                                    |
| ------------------------------------------ | ------------------------------------------------------------------------------ |
| [CODEOWNERS](./CODEOWNERS)                 | Outlines the project lead(s)                                                   |
| [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md) | Expected behavior for project contributors, promoting a welcoming environment |
| [CONTRIBUTING.md](./CONTRIBUTING.md)       | Developer guide to build, test, run, access CI, chat, discuss, file issues     |
| [GOVERNANCE.md](./GOVERNANCE.md)           | Project governance                                                             |
| [LICENSE](./LICENSE)                       | Apache License, Version 2.0                                                    |

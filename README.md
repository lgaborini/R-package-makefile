# R-package-makefile

This is a simple Makefile to build an R package.

## Usage

Put it in a package root (next to the DESCRIPTION).

## Supported actions

As Makefile targets:

- `document`: document using {devtools}
- `source_package`: build a source package
- `binary_package`: build a binary package
- `packages`: build source and binary packages
- `pkgdown`: build a {pkgdown} site
- `drat`: push source and binary packages to a {drat} repository
- `targets`: show Makefile variables and dependencies
- `all`: everything (except `targets`)

The Makefile is still in development!  
I am sure some actions can be improved: feel free to fork or submit a pull request.

## Requirements

- R with the desired packages
- GNU Make >= 4.3
  - Enables grouped explicit targets, to avoid documenting unnecessarily
  - Windows: get it from [Chocolatey](https://community.chocolatey.org/packages/make)
- GNU tools: `sed`, `head` to extract the package version.

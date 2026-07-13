# Changelog

Format based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/).

## **[Unreleased]**

### Changed

* Forked from [wasmerio/wasmer-php](https://github.com/wasmerio/wasmer-php)
* Upgraded to Wasmer 7.x
* Minimum PHP version raised to 8.3
* Wasmer library downloaded at build time instead of shipped in repo
* Fixed resource ownership semantics for Wasmer 7.x API changes

### Removed

* LLVM and Singlepass compiler backend tests (unavailable in Wasmer 7.x build)
* Object file engine tests (removed in Wasmer 4+)

[Unreleased]: https://github.com/evergreen-connect/php-webassm

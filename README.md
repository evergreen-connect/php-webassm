# php-webassm

PHP bindings for the [Wasmer](https://github.com/wasmerio/wasmer) WebAssembly runtime.

Fork of [wasmerio/wasmer-php](https://github.com/wasmerio/wasmer-php), modernized for Wasmer 7.x and PHP 8.3+.

## Requirements

- PHP 8.3+
- Linux (x86_64 or aarch64)
- Standard C build tools (`make`, `gcc`/`clang`)

Other Unix-like systems (macOS, FreeBSD) may work but are not tested.

## Install

```bash
git clone https://github.com/evergreen-connect/php-webassm
cd php-webassm
make ext/configure   # downloads Wasmer 7.2.0, runs phpize + configure
make ext/all         # builds ext/modules/wasm.so
make ext/test        # runs the test suite
```

To target a specific PHP install:

```bash
make ext/configure PHP_HOME=/path/to/php
```

Load the extension:

```bash
php -dextension=ext/modules/wasm.so your_script.php
```

Or add to your `php.ini`:

```ini
extension=/absolute/path/to/ext/modules/wasm.so
```

## Quick start

### Procedural API

```php
<?php

$engine = wasm_engine_new();
$store = wasm_store_new($engine);
$wasm = file_get_contents('hello.wasm');
$module = wasm_module_new($store, $wasm);

function hello_callback() {
    echo '> Hello World!' . PHP_EOL;
}

$functype = wasm_functype_new(new Wasm\Vec\ValType(), new Wasm\Vec\ValType());
$func = wasm_func_new($store, $functype, 'hello_callback');
$extern = wasm_func_as_extern($func);
$externs = new Wasm\Vec\Extern([$extern]);
$instance = wasm_instance_new($store, $module, $externs);

$exports = wasm_instance_exports($instance);
$run = wasm_extern_as_func($exports[0]);
$results = wasm_func_call($run, new Wasm\Vec\Val());
```

### Object-oriented API

```php
<?php

require_once __DIR__.'/../vendor/autoload.php';

$engine = Wasm\Engine::new();
$store = Wasm\Store::new($engine);
$wasm = file_get_contents('hello.wasm');
$module = Wasm\Module::new($store, $wasm);

function hello_callback() {
    echo '> Hello World!' . PHP_EOL;
}

$functype = Wasm\Type\FuncType::new(new Wasm\Vec\ValType(), new Wasm\Vec\ValType());
$func = Wasm\Func::new($store, $functype, 'hello_callback');

$extern = $func->asExtern();
$externs = new Wasm\Vec\Extern([$extern->inner()]);
$instance = Wasm\Instance::new($store, $module, $externs);

$exports = $instance->exports();
$run = (new Wasm\Extern($exports[0]))->asFunc();
$results = $run(new Wasm\Vec\Val());
```

More examples in [examples/](examples) (OO API) and [ext/examples/](ext/examples) (procedural API).

## Make targets

| Target | Description |
|---|---|
| `make ext/download` | Download Wasmer for current platform |
| `make ext/configure` | phpize + configure (auto-downloads Wasmer if missing) |
| `make ext/all` | Build the extension |
| `make ext/test` | Run phpt tests |
| `make ext/examples` | Run procedural API examples |
| `make ext/clean` | Clean build artifacts |
| `make test-unit` | Run OO interface unit tests (PHPUnit) |
| `make test-examples` | Run OO interface examples (PHPUnit) |
| `make test-doc-examples` | Run examples/*.php directly |
| `make test-all` | Run everything |
| `make lint` | php-cs-fixer dry run |

## Wasmer version

Set `WASMER_VERSION` to download a different release:

```bash
WASMER_VERSION=7.3.0 make ext/download
```

## Platform support

| Platform | Architecture | Status |
|---|---|:---:|
| Linux | x86_64 | ✅ Tested |
| Linux | aarch64 | ✅ Supported |

macOS and other Unix-like systems may work (the download script and build support them) but are not CI-tested.

## License

MIT. See [LICENSE](LICENSE).

Based on [wasmerio/wasmer-php](https://github.com/wasmerio/wasmer-php) by the Wasmer Engineering Team.

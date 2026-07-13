--TEST--
Module API: wasm_module_validate

--FILE--
<?php

$engine = wasm_engine_new();
$store = wasm_store_new($engine);
$wasm = wat2wasm('(module)');
var_dump(wasm_module_validate($store, $wasm));
var_dump(wasm_module_validate($store, 'invalid'));

?>
--EXPECTF--
bool(true)
bool(false)

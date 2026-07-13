#include "wasmer.h"
#include <stdlib.h>
#include <string.h>

// Wasmer v7 dropped several wasm C API functions that the spec declares
// in wasm.h via WASM_DECLARE_TYPE macros. Provide implementations so
// the extension links.

wasm_globaltype_t *wasm_globaltype_copy(wasm_globaltype_t *gt) {
    if (!gt) return NULL;
    return wasm_globaltype_new(
        wasm_valtype_new(wasm_valtype_kind(wasm_globaltype_content(gt))),
        wasm_globaltype_mutability(gt)
    );
}

wasm_tabletype_t *wasm_tabletype_copy(wasm_tabletype_t *tt) {
    if (!tt) return NULL;
    const wasm_limits_t *lim = wasm_tabletype_limits(tt);
    return wasm_tabletype_new(
        wasm_valtype_new(wasm_valtype_kind(wasm_tabletype_element(tt))),
        lim
    );
}

wasm_memorytype_t *wasm_memorytype_copy(wasm_memorytype_t *mt) {
    if (!mt) return NULL;
    const wasm_limits_t *lim = wasm_memorytype_limits(mt);
    return wasm_memorytype_new(lim);
}

wasm_valtype_t *wasm_valtype_copy(wasm_valtype_t *vt) {
    if (!vt) return NULL;
    return wasm_valtype_new(wasm_valtype_kind(vt));
}

wasm_module_t *wasm_module_copy(const wasm_module_t *m) {
    (void)m;
    return NULL;
}

wasm_instance_t *wasm_instance_copy(const wasm_instance_t *i) {
    (void)i;
    return NULL;
}

wasm_trap_t *wasm_trap_copy(const wasm_trap_t *t) {
    (void)t;
    return NULL;
}

void wasm_foreign_delete(wasm_foreign_t *f) {
    (void)f;
}

void wasm_externtype_vec_delete(wasm_externtype_vec_t *v) {
    if (v && v->data) {
        for (size_t i = 0; i < v->size; i++) {
            if (v->data[i]) wasm_externtype_delete(v->data[i]);
        }
        free(v->data);
        v->data = NULL;
        v->size = 0;
    }
}

void wasm_externtype_vec_new_empty(wasm_externtype_vec_t *v) {
    v->size = 0;
    v->data = NULL;
}

void wasm_externtype_vec_new_uninitialized(wasm_externtype_vec_t *v, size_t len) {
    v->size = len;
    v->data = len ? calloc(len, sizeof(wasm_externtype_t *)) : NULL;
}

#pragma once

#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif
#include <Windows.h>

EXTERN_C HRESULT __wine_register_resources(HMODULE);
EXTERN_C HRESULT __wine_unregister_resources(HMODULE);

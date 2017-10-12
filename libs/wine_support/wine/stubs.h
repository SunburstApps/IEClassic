#ifndef WIN32_LEAN_AND_MEAN
#include <Windows.h>
#endif

#define EH_NONCONTINUABLE   0x01
#define EH_UNWINDING        0x02
#define EH_EXIT_UNWIND      0x04
#define EH_STACK_INVALID    0x08
#define EH_NESTED_CALL      0x10

#define EXCEPTION_WINE_STUB       0x80000100
#define EXCEPTION_WINE_ASSERTION  0x80000101

EXTERN_C VOID WINAPI RaiseException(DWORD dwExceptionCode, DWORD dwExceptionFlags, DWORD nNumberOfArguments, const ULONG_PTR *lpArguments);

#define __wine_spec_unimplemented_stub(module, function) \
	do { \
		ULONG_PTR args[2]; \
		args[0] = (ULONG_PTR)module; \
		args[1] = (ULONG_PTR)function; \
		RaiseException(EXCEPTION_WINE_STUB, EH_NONCONTINUABLE, 2, args); \
	} while (0)

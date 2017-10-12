#include "registrar.h"
#include <atlbase.h>
#include <atlstr.h>
#include <atliface.h>

namespace /* anonymous */
{
	HMODULE atl100;
	HRESULT(WINAPI * pAtlCreateRegistrar)(IRegistrar **);

	struct registrar_info
	{
		CComPtr<IRegistrar> registrar;
		bool do_register;
		HRESULT result;

		registrar_info(bool flag, HMODULE instance) : do_register(flag)
		{
			if (pAtlCreateRegistrar == nullptr)
			{
				atl100 = ::LoadLibrary(_T("ATL100.dll"));
				if (atl100 == nullptr) {
					registrar = nullptr;
					result = E_NOINTERFACE;
					return;
				}

				pAtlCreateRegistrar = (decltype(pAtlCreateRegistrar))::GetProcAddress(atl100, "AtlCreateRegistrar");
				if (pAtlCreateRegistrar == nullptr)
				{
					registrar = nullptr;
					result = E_NOINTERFACE;
					return;
				}
			}

			HRESULT hr = pAtlCreateRegistrar(&registrar);
			if (SUCCEEDED(hr))
			{
				WCHAR str[MAX_PATH];
				GetModuleFileNameW(instance, str, MAX_PATH);
				registrar->AddReplacement(W2OLE(_T("MODULE")), W2OLE(str));
			}

			result = S_OK;
		}
	};

	BOOL CALLBACK register_resource(HMODULE instance, LPCWSTR type, LPWSTR name, LONG_PTR arg)
	{
		USES_CONVERSION;
		registrar_info *info = (registrar_info *)arg;

		HRSRC rsrc = ::FindResource(instance, name, type);
		char *str = (char *)::LoadResource(instance, rsrc);
		LPOLESTR wstr = A2OLE(str);
		if (wstr == nullptr) {
			info->result = E_OUTOFMEMORY;
			return false;
		}

		if (info->do_register) info->result = info->registrar->StringRegister(wstr);
		else info->result = info->registrar->StringUnregister(wstr);

		return SUCCEEDED(info->result);
	}
}

HRESULT __wine_register_resources(HMODULE instance)
{
	registrar_info info(true, instance);
	if (FAILED(info.result)) return info.result;
	::EnumResourceNames(instance, _T("WINE_REGISTRY"), register_resource, (LONG_PTR)&info);
	return info.result;
}

HRESULT __wine_unregister_resources(HMODULE instance)
{
	registrar_info info(false, instance);
	if (FAILED(info.result)) return info.result;
	::EnumResourceNames(instance, _T("WINE_REGISTRY"), register_resource, (LONG_PTR)&info);
	return info.result;
}

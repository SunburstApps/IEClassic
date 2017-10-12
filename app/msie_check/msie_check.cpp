#include "msie_check.h"
#include <atlstr.h>
#include <winver.h>

BOOL IsMicrosoftIE(void)
{
	LPCTSTR browseui = _T("C:\\Windows\\System32\\browseui.dll");

	DWORD handle;
	DWORD size = ::GetFileVersionInfoSize(browseui, &handle);

	void *buf = ::HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, size);
	::GetFileVersionInfo(browseui, 0, size, buf);

	LPWORD translation; UINT valueSize;
	if (::VerQueryValue(buf, _T("\\VarFileInfo\\Translation"), (void **)translation, &valueSize))
	{
		CString descriptionPath; descriptionPath.Format(_T("\\StringFileInfo\\%04x%04x\\FileDescription"), translation[0], translation[1]);

		CString fileDescription;
		LPWSTR fileDescriptionString = fileDescription.GetBuffer(48);
		::VerQueryValue(buf, descriptionPath.GetString(), (void **)&fileDescriptionString, &valueSize);
		fileDescription.ReleaseBuffer();

		// If browseui.dll's description string contains either "Wine" or "ReactOS", then we can be fairly certain
		// that we're running on Wine/ReactOS. If not, we assume that we are running under Windows with Microsoft
		// Internet Explorer installed.
		return (fileDescription.Find(_T("Wine")) == -1 && fileDescription.Find(_T("ReactOS")) == -1);
	}

	// If we can't find the value, we assume Windows with Microsoft Internet Explorer to be safe.
	return true;
}

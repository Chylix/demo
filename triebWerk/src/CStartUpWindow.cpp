#include <CStartUpWindow.h>
// Windows Header Files:
#include <windows.h>
#include <CommCtrl.h>

// C RunTime Header Files
#include <math.h>

#include <objbase.h>


#ifndef HINST_THISCOMPONENT
EXTERN_C IMAGE_DOS_HEADER __ImageBase;
#define HINST_THISCOMPONENT ((HINSTANCE)&__ImageBase)
#endif


triebWerk::CStartUpWindow::CStartUpWindow()
{
}

triebWerk::CStartUpWindow::~CStartUpWindow()
{
}

void triebWerk::CStartUpWindow::Initialize()
{
	triebWerk::SEngineConfiguration config;

	//Window
	config.m_WindowConfig.m_IconID = 1021;
	config.m_WindowConfig.m_WindowName = "Settings";
	config.m_WindowConfig.m_WindowStyle = WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX;

	config.m_Width = 300;
	config.m_Height = 200;
	config.m_Fullscreen = false;
	config.m_VSync = false;
	config.m_MasterVolume = 1.0f;
	config.m_BGMVolume = 0.6f;
	config.m_SFXVolume = 1.0f;

	m_pWindow = new CWindow();
	m_pWindow->Initialize(false, config.m_Width, config.m_Height, config.m_WindowConfig);

	int xpos = 50;            // Horizontal position of the window.
	int ypos = 50;            // Vertical position of the window.
	int nwidth = 200;          // Width of the window
	int nheight = 200;         // Height of the window
	HWND hwndParent = m_pWindow->GetWindowHandle(); // Handle to the parent window

	HWND hWndComboBox = CreateWindow(WC_COMBOBOX, TEXT(""),
		CBS_DROPDOWN | CBS_HASSTRINGS | WS_CHILD | WS_OVERLAPPED | WS_VISIBLE,
		xpos, ypos, nwidth, nheight, hwndParent, NULL, HINST_THISCOMPONENT,
		NULL);

	TCHAR Planets[9][10] =
	{
		TEXT("Mercury"), TEXT("Venus"), TEXT("Terra"), TEXT("Mars"),
		TEXT("Jupiter"), TEXT("Saturn"), TEXT("Uranus"), TEXT("Neptune"),
		TEXT("Pluto??")
	};

	TCHAR A[16];
	int  k = 0;

	memset(&A, 0, sizeof(A));
	for (k = 0; k <= 8; k += 1)
	{
		//wcscpy_s(A, sizeof(A) / sizeof(TCHAR), (TCHAR*)Planets[k]);

		// Add string to combobox.
		SendMessage(hWndComboBox, (UINT)CB_ADDSTRING, (WPARAM)0, (LPARAM)A);
	}

	// Send the CB_SETCURSEL message to display an initial item 
	//  in the selection field  
	SendMessage(hWndComboBox, CB_SETCURSEL, (WPARAM)2, (LPARAM)0);
}

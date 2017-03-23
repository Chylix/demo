#pragma once
#include <CWindow.h>

namespace triebWerk
{
	class CStartUpWindow
	{
	public:
		CStartUpWindow();
		~CStartUpWindow();

	public:
		void Initialize();

	private:
		CWindow* m_pWindow;
		

	};
}

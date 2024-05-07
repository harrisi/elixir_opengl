-module(wx_const).
-compile(nowarn_export_all).
-compile(export_all).

-include_lib("wx/include/wx.hrl").

wx_id_any() -> ?wxID_ANY.

wx_gl_core_profile() -> ?WX_GL_CORE_PROFILE.
wx_gl_major_version() -> ?WX_GL_MAJOR_VERSION.
wx_gl_minor_version() -> ?WX_GL_MINOR_VERSION.
wx_gl_doublebuffer() -> ?WX_GL_DOUBLEBUFFER.

-module(gl_const).
-compile(nowarn_export_all).
-compile(export_all).

-include_lib("wx/include/gl.hrl").

gl_vertex_shader() -> ?GL_VERTEX_SHADER.
gl_fragment_shader() -> ?GL_FRAGMENT_SHADER.

gl_array_buffer() -> ?GL_ARRAY_BUFFER.

gl_static_draw() -> ?GL_STATIC_DRAW.

gl_float() -> ?GL_FLOAT.

gl_false() -> ?GL_FALSE.

gl_color_buffer_bit() -> ?GL_COLOR_BUFFER_BIT.

gl_triangles() -> ?GL_TRIANGLES.

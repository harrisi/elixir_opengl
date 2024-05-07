defmodule ElixirOpengl do
  @moduledoc """
  Simple triangle rendering with Elixir.
  """

  import WxRecords

  @behaviour :wx_object

  @doc """
  This will handle setup stuff, such as creating the main window, OpenGL
  context, etc.
  """
  @impl :wx_object
  def init(_config) do
    opts = [size: {800, 600}]

    wx = :wx.new()

    frame = :wxFrame.new(wx, :wx_const.wx_id_any, 'Elixir OpenGL', opts)

    :wxWindow.connect(frame, :close_window)

    :wxFrame.show(frame)

    gl_attrib = [
      attribList: [
        :wx_const.wx_gl_core_profile,
        :wx_const.wx_gl_major_version, 3,
        :wx_const.wx_gl_minor_version, 3,
        :wx_const.wx_gl_doublebuffer,
        0
      ]
    ]

    canvas = :wxGLCanvas.new(frame, opts ++ gl_attrib)
    ctx = :wxGLContext.new(canvas)

    :wxGLCanvas.setCurrent(canvas, ctx)

    {shader_program, vao} = init_opengl()

    send(self(), :update)

    {frame, %{
      frame: frame,
      canvas: canvas,
      shader_program: shader_program,
      vao: vao,
    }}
  end

  @impl :wx_object
  def handle_event(wx(event: wxClose()), state) do
    {:stop, :normal, state}
  end

  @impl :wx_object
  def handle_info(:stop, %{canvas: canvas} = state) do
    :wxGLCanvas.destroy(canvas)

    {:stop, :normal, state}
  end

  @impl :wx_object
  def handle_info(:update, state) do
    render(state)

    {:noreply, state}
  end

  defp init_opengl() do
    vertex_source = '#version 330 core
layout (location = 0) in vec3 aPos;
void main() {
  gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
}\0'

    fragment_source = '#version 330 core
out vec4 FragColor;
void main() {
  FragColor = vec4(0.4f, 0.2f, 0.6f, 1.0f);
}\0'

    vertex_shader = :gl.createShader(:gl_const.gl_vertex_shader)
    :gl.shaderSource(vertex_shader, [vertex_source])
    :gl.compileShader(vertex_shader)

    fragment_shader = :gl.createShader(:gl_const.gl_fragment_shader)
    :gl.shaderSource(fragment_shader, [fragment_source])
    :gl.compileShader(fragment_shader)

    shader_program = :gl.createProgram()
    :gl.attachShader(shader_program, vertex_shader)
    :gl.attachShader(shader_program, fragment_shader)
    :gl.linkProgram(shader_program)

    :gl.deleteShader(vertex_shader)
    :gl.deleteShader(fragment_shader)

    vertices = [
      -0.5, -0.5, 0.0,
       0.5, -0.5, 0.0,
       0.0,  0.5, 0.0,
    ] |> Enum.reduce(<<>>, fn el, acc -> acc <> <<el::float-native-size(32)>> end)

    [vao] = :gl.genVertexArrays(1)
    [vbo] = :gl.genBuffers(1)

    :gl.bindVertexArray(vao)

    :gl.bindBuffer(:gl_const.gl_array_buffer, vbo)
    :gl.bufferData(:gl_const.gl_array_buffer, byte_size(vertices), vertices, :gl_const.gl_static_draw)

    :gl.vertexAttribPointer(0, 3, :gl_const.gl_float, :gl_const.gl_false, 3 * byte_size(<<0.0::float-size(32)>>), 0)
    :gl.enableVertexAttribArray(0)

    :gl.bindBuffer(:gl_const.gl_array_buffer, 0)

    :gl.bindVertexArray(0)

    {shader_program, vao}
  end

  defp render(%{canvas: canvas} = state) do
    draw(state)
    :wxGLCanvas.swapBuffers(canvas)
    send(self(), :update)

    :ok
  end

  defp draw(%{shader_program: shader_program, vao: vao} = _state) do
    :gl.clearColor(0.2, 0.1, 0.3, 1.0)
    :gl.clear(:gl_const.gl_color_buffer_bit)

    :gl.useProgram(shader_program)

    :gl.bindVertexArray(vao)
    :gl.drawArrays(:gl_const.gl_triangles, 0, 3)

    :ok
  end
end

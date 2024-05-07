defmodule ElixirOpengl do
  @moduledoc """
  Simple triangle rendering with Elixir.
  """

  @behaviour :wx_object

  @impl :wx_object
  def init(_config) do
    # this will handle setup stuff, such as creating the main window, OpenGL
    # context, etc.
    :ignore
  end

  @impl :wx_object
  def handle_event(_request, _state) do
    {:noreply, nil}
  end
end

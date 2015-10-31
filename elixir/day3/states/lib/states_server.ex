defmodule States.Server do
  use GenServer
  require VidStore

  def start_link(vs) do
    GenServer.start_link(__MODULE__, vs, name: :video_store)
  end

  def init(vs) do
    {:ok, vs}
  end

  # returns a specific video
  def handle_call({action, item}, _from, vs) do
    v  = vs[item]
    nv = apply VidStore, action, [v]
    {:reply, nv, Keyword.put(vs, item, nv)}
  end

  # don't care abt. result
  def handle_cast({:add, v}, vs) do
    {:noreply, [v|vs]}
  end
end

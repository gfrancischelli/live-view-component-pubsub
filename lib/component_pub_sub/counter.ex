defmodule CompPS.Counter do
  use GenServer

  alias CompPSWeb.LiveViewPubSub

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{count: 0})
  end

  def init(state) do
    schedule_tick()
    {:ok, state}
  end

  def handle_info(:tick, %{count: count} = state) do
    LiveViewPubSub.broadcast("counter", {:counter, count})
    schedule_tick()
    {:noreply, %{state | count: count + 1}}
  end

  defp schedule_tick do
    Process.send_after(self(), :tick, 1000)
  end
end

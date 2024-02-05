defmodule CompPSWeb.LiveViewPubSub do
  def subscribe_live_view(topic) do
    Phoenix.PubSub.subscribe(CompPS.PubSub, topic, metadata: :live_view)
  end

  def subscribe_live_component(topic, mod, id) do
    Phoenix.PubSub.subscribe(CompPS.PubSub, topic, metadata: {:live_component, mod, id})
  end

  def broadcast(topic, message) do
    Phoenix.PubSub.broadcast(CompPS.PubSub, topic, message, CompPS.Dispatcher)
  end
end

defmodule CompPS.Dispatcher do
  def dispatch(entries, :none, message) do
    for {pid, meta} <- entries do
      case meta do
        :live_view ->
          send(pid, message)

        {:live_component, mod, id} ->
          update = message |> List.wrap() |> Kernel.++(id: id)
          Phoenix.LiveView.send_update(pid, mod, update)
      end
    end

    :ok
  end
end

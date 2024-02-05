defmodule CompPSWeb.DemoLive do
  use CompPSWeb, :live_view
  alias CompPSWeb.LiveViewPubSub

  def mount(_session, _params, socket) do
    LiveViewPubSub.subscribe_live_view("counter")
    {:ok, assign(socket, :counter, nil)}
  end

  def render(assigns) do
    ~H"""
    LiveView <%= @counter %>

    <.live_component id="counter" module={CompPSWeb.LiveComponent} />
    """
  end

  def handle_info({:counter, count}, socket) do
    {:noreply, assign(socket, counter: count)}
  end

  def terminate() do
    PubSub.unsuber()
  end
end

defmodule CompPSWeb.LiveComponent do
  use CompPSWeb, :live_component
  alias CompPSWeb.LiveViewPubSub

  def render(assigns) do
    ~H"""
    <div id={@id}>
      LiveComponent <%= @counter %>
    </div>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, counter: nil, subscribed: false)}
  end

  def update(%{id: id} = assigns, %{assigns: %{subscribed: false}} = socket) do
    LiveViewPubSub.subscribe_live_component("counter", __MODULE__, id)
    {:ok, assign(socket, assigns) |> assign(:subscribed, true)}
  end

  def update(%{counter: count}, socket) do
    {:ok, assign(socket, counter: count)}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end
end

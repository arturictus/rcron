defmodule Beat.Ruby do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, [])
  end

  def init(_) do
    ruby = init_instance("/Users/arturpanach/code/rcron_app_example/bin/rcron_callback")
    {:ok, ruby}
  end

  def handle_call({:send, message}, from, ruby) do
    IO.puts("handleling call self")
    IO.puts("handleling call #{inspect(ruby)}")
    send_message(ruby, message)
    receive do
      {_, {:data, data}} ->
      case data |> decode_data do
        {:result, result} ->
          IO.puts("ruby responded:")
          IO.puts(inspect(result))
        _ -> {:error, "Unknown message"}
      end
    end
    {:reply, nil, ruby}
  end

  def init_instance(script) do
    Port.open({:spawn, script}, [{:packet, 4}, :nouse_stdio, :exit_status, :binary])
  end

  def send_message(pid, data) do
    command = data |> Poison.encode!
    encoded_msg = {:execute, command} |> encode_data
    pid |> Port.command(encoded_msg)
  end

  defp encode_data(data) do
    data |> :erlang.term_to_binary
  end

  defp decode_data(data) do
    data |> :erlang.binary_to_term
  end

end

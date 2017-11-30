defmodule Beat.Bridge do
  alias Beat.Ruby
  # @ruby_echo Path.expand("../bin/exec", '.')
  @ruby_echo "/Users/arturpanach/code/rcron_app_example/bin/rcron_callback"

  @script "#{@ruby_echo}"
  @timeout 60000

  # def execute(data) do
  #   command = data |> Poison.encode!
  #   pid = Ruby.init_instance(@script)
  #     #Port.open({:spawn, @script}, [{:packet, 4}, :nouse_stdio, :exit_status, :binary])
  #
  #   encoded_msg = {:execute, command} |> encode_data
  #
  #   pid |> Ruby.send_message(encoded_msg)
  #
  #   receive do
  #     {_, {:data, data}} ->
  #     case data |> decode_data do
  #       {:result, result} ->
  #         IO.puts("ruby responded:")
  #         IO.puts(inspect(result))
  #       _ -> {:error, "Unknown message"}
  #     end
  #   end
  # end

  def execute(data, "poolboy") do
     :poolboy.transaction(
       :worker,
       fn pid -> GenServer.call(pid, {:send, data}) end,
       @timeout
     )
     # receive do
     #   {_, {:data, data}} ->
     #   case data |> decode_data do
     #     {:result, result} ->
     #       IO.puts("ruby responded:")
     #       IO.puts(inspect(result))
     #     _ -> {:error, "Unknown message"}
     #   end
     # end
  end

  # def execute(pid, data) do
  #   command = data |> Poison.encode!
  #   # pid = Ruby.start(@script)
  #     #Port.open({:spawn, @script}, [{:packet, 4}, :nouse_stdio, :exit_status, :binary])
  #
  #   encoded_msg = {:execute, command} |> encode_data
  #
  #   pid |> Ruby.send(encoded_msg)
  #
  #   receive do
  #     {_, {:data, data}} ->
  #     case data |> decode_data do
  #       {:result, result} ->
  #         IO.puts("ruby responded:")
  #         IO.puts(inspect(result))
  #       _ -> {:error, "Unknown message"}
  #     end
  #   end
  # end

  defp encode_data(data) do
    data |> :erlang.term_to_binary
  end

  defp decode_data(data) do
    data |> :erlang.binary_to_term
  end
end

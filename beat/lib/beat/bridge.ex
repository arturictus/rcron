defmodule Beat.Bridge do
  @ruby_echo Path.expand("../bin/exec", '.')

  @script "#{@ruby_echo}"

  def execute(data) do
    command = data |> Poison.encode!
    pid = Port.open({:spawn, @script}, [{:packet, 4}, :nouse_stdio, :exit_status, :binary])

    encoded_msg = {:execute, command} |> encode_data

    pid |> Port.command(encoded_msg)

    receive do
      {_, {:data, data}} ->
      case data |> decode_data do
        {:result, result} -> IO.puts(inspect(result))
        _ -> {:error, "Unknown message"}
      end
    end
  end

  defp encode_data(data) do
    data |> :erlang.term_to_binary
  end

  defp decode_data(data) do
    data |> :erlang.binary_to_term
  end
end

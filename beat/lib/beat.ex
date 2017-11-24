defmodule Beat do
  @moduledoc """
  Documentation for Beat.
  """

  def tasks_file do
    System.get_env("RCRON_CONFIG") || Path.expand("~/rcron_config.yml")
  end

  def tasks_file_content do
    File.read!(tasks_file)
  end

  def tasks do
    tasks_file_content
    |> YamlElixir.read_from_string
  end

  def add_tasks do
    tasks["tasks"]
  end


end

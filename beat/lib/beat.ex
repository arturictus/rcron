defmodule Beat do
  @moduledoc """
  Documentation for Beat.
  """

  def tasks_file do
    System.get_env("RCRON_CONFIG") || Path.expand("~/rcron_config.yml")
  end

  def tasks do
    File.read!(tasks_file)
  end
end

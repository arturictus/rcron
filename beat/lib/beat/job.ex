defmodule Beat.Job do
  import Crontab.CronExpression
  alias Crontab.CronExpression.Parser
  alias Beat.Bridge

  def build(%{} = data) do
    Beat.Scheduler.new_job()
    |> set_name(data)
    |> set_schedule(data)
    |> set_task(data)
  end

  def add(job) do
    job
    |> Beat.Scheduler.add_job()
  end

  defp set_name(job, %{"name" => name}) do
    job
    |> Quantum.Job.set_name(name)
  end
  defp set_name(job, _data), do: job

  defp set_schedule(job, %{"schedule" => schedule, "extended" => true}) do
    job
    |> Quantum.Job.set_schedule(Parser.parse!(schedule, true))
  end
  defp set_schedule(job, %{"schedule" => schedule}) do
    job
    |> Quantum.Job.set_schedule(Parser.parse!(schedule, false))
  end

  defp set_task(job, data) do
    job
    |> Quantum.Job.set_task(fn ->
      data
      |> Bridge.execute("poolboy")
    end)
  end

end

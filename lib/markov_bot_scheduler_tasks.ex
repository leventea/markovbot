defmodule MarkovBot.Scheduler.Tasks do
  import File
  import Application
  import Path, only: [ join: 2, absname: 1, basename: 2 ]
  import Enum, only: [ filter: 2, map: 2, each: 2 ]

  def backup_dir do
    absname(get_env(:markov_bot, :backup_dir))
  end

  def autosave_file do
    absname(get_env(:markov_bot, :autosave_path))
  end

  def autosave do
    path = autosave_file()
    SentenceProvider.save_state(SentenceProvider, path)
  end

  def backup(filename \\ nil) do
    source_path = autosave_file()

    if exists?(source_path) do
      dir = backup_dir()
      formatted_filename = unless filename do
        formatted_time()
      else
        filename
      end <> ".chain"

      dest_path = join(dir, formatted_filename)

      mkdir_p(dir)
      cp(source_path, dest_path)

      {:ok, dest_path}
    else
      {:error, :file_not_found}
    end
  end

  defp formatted_time do
    dt = DateTime.utc_now
    DateTime.to_iso8601(dt)
  end

  def purge_backups do
    now = DateTime.utc_now
    time_threshold = get_env(:markov_bot, :keep_backups_for) * 86400 # seconds in a day

    files = ls!(backup_dir())
    |> map(fn f -> join(backup_dir(), f) end)
    |> filter(&regular?/1)
    |> map(fn f ->
      case DateTime.from_iso8601(basename(f, ".chain")) do
        { :ok, dt, _offset } -> { f, dt }
        { :error, _atom } -> { f, nil }
      end
    end)
    |> filter(fn { _f, dt } ->
      dt != nil
      and DateTime.diff(now, dt) > time_threshold
    end)

    delete = map(files, fn { f, _dt } -> f end)
    each(delete, fn f -> rm(f) end)

    delete
  end
end

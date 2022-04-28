defmodule TelegramExportParser do
  alias Jason, as: J
  import Enum

  defp parse_file(filepath) when is_binary(filepath) do
    J.decode!(File.read!(filepath))
  end

  defp parse_messages(obj) when is_map(obj) do
    filter(obj["messages"], fn i ->
      case i["text"] do
        x when not is_binary(x) -> false
        "" -> false
        _ -> true
      end
    end) |> map(fn i -> i["text"] end)
  end

  def get_messages(filepath) when is_binary(filepath) do
    parse_messages(parse_file(filepath))
  end
end

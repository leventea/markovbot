defmodule TelegramBot.Helpers do
  alias Nadia, as: N

  # message helpers

  @doc """
  Returns the invoked command's name, or nil if the message does not contain one.
  """
  def parse_command(msg) do
    ents = msg.entities

    if ents != nil do
      cmds = Enum.filter(ents, fn ent -> ent.type == "bot_command" end)
      cmd_ent = List.first(cmds)

      if cmd_ent != nil do
        if String.contains?(msg.text, "@") do
          parse_targeted_command(msg.text)
        else
          String.slice(msg.text, (cmd_ent.offset + 1)..cmd_ent.length)
        end
      else nil end
    else nil end
  end

  @doc """
  A targeted command also contains the @ of the invoked bot.
  Ex.: /start@example_bot (instead of /start alone)

  Returns nil if the provided handle differs from the bot's own,
  otherwise it returns the invoked command's name.
  """
  defp parse_targeted_command(text) do
    split = String.split(text, "@", parts: 2, trim: true)

    uname = List.last(split)
    cmd = List.first(split)
    {:ok, me} = Nadia.get_me()

    if me.username == uname do
      String.trim_leading(cmd, "/")
    else
      :invalid
    end
  end

  def has_valid_msg(update) do
        update.edited_message == nil
    and update.message.text != nil
    and String.length(update.message.text) > 0
    and update.message.chat.id == -1001382033469 # TODO: don't hardcode
  end

  def reply(message, text, opts \\ []) do
    chat_id = message.chat.id

    N.send_message(chat_id, text, [reply_to_message_id: message.message_id] ++ opts)
  end

end

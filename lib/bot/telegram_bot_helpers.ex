defmodule TelegramBot.Helpers do
  alias Nadia, as: N

  # message helpers

  @doc "Returns the name of the command, or nil if there's no command in the message"
  def parse_command(msg) do
    ents = msg.entities

    if ents != nil do
      cmds = Enum.filter(ents, fn ent -> ent.type == "bot_command" end)
      cmd_ent = List.first(cmds)

      if cmd_ent != nil do
        String.slice(msg.text, (cmd_ent.offset + 1)..cmd_ent.length)
      else nil end
    else nil end
  end

  def has_valid_msg(update) do
        update.edited_message == nil
    and update.message.text != nil
    and String.length(update.message.text) > 0
  end

  def reply(message, text, opts \\ []) do
    chat_id = message.chat.id

    N.send_message(chat_id, text, [reply_to_message_id: message.message_id] ++ opts)
  end

end

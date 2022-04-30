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
          #NOTE: bug here? idk
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

  @doc """
  Returns true if the message is in reply to the bot.
  """
  def is_reply?(msg) do
    {:ok, me} = Nadia.get_me()

        msg.reply_to_message != nil
    and msg.reply_to_message.from.id == me.id
  end

  @doc """
  Return a list of mentions or nil if there are none.
  """
  defp mentions(msg) do
    if msg.entities != nil do
      mentions = Enum.filter(msg.entities, fn ent -> ent.type == "mention" end)

      unless Enum.empty?(mentions) do
        Enum.map(mentions, fn mention ->
          range = (mention.offset + 1) .. (mention.offset + mention.length)

          String.trim(String.slice(msg.text, range))
        end)
      end
    else nil end
  end
  
  @doc """
  Returns true if the message mentions the bot.
  """
  def is_mentioned?(msg) do
    ments = mentions(msg)
    {:ok, me} = Nadia.get_me()

    me.username in ments
  end

  @doc """
  Returns true if the bot has to reply to the message.
  """
  def guaranteed_reply?(msg) do
    is_reply?(msg) or is_mentioned?(msg)
  end

  def has_valid_msg(update) do
        update.edited_message == nil            # ignore edited messages
    and update.message.text != nil              # ignore messages with empty text fields (images, stickers, etc..)
    and String.length(update.message.text) > 0  # ignore messages with 0 length text fields
    and update.message.chat.id == -1001382033469 # TODO: don't hardcode
  end

  def reply(message, text, opts \\ []) do
    chat_id = message.chat.id

    N.send_message(chat_id, text, [reply_to_message_id: message.message_id] ++ opts)
  end

end

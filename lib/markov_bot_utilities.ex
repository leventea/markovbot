defmodule MarkovBot.Utilties do
  def train_from_telegram(path) do
    messages = TelegramExportParser.get_messages(Path.absname(path))

    SentenceProvider.train(SentenceProvider, messages)
  end
end

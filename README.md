# MarkovBot

A Telegram bot that trains a markov chain on your group chat. 

## Running

- Clone the repository and configure the bot in `config/config.exs`.
- Run `mix deps.get` to install the dependencies
- `mix run` to run normally OR `iex -S mix` for a REPL

# Training the bot on a Telegram Export

The `MarkovBot.Utilities` module contains a helper function that trains the bot on a JSON Telegram export.

- Open a REPL (`iex -S mix`)
- Run `MarkovBot.Utilties.train_from_telegram(path_to_file)`
- Force an auto-save to write the chain to disk via `MarkovBot.Scheduler.Tasks.autosave`

# Defaults

By default the built-in cron service will auto-save the chain to disk every 15 minutes,
create a backup every day, and purge old backups every week (which are kept for 7 days by default)

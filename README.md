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

Note: In case you wish to return the chain to its previous state later, force a backup with a non-timestamp name (only timestamped files get purged) via
`MarkovBot.Scheduler.Tasks.backup(backup_name_here)`

- Force an auto-save to write the chain to disk via `MarkovBot.Scheduler.Tasks.autosave`

# Updating the configuration at runtime

You can update the config at runtime with built-in Elixir utilities from the Application module,
such as `put_env` or `put_all_env`. However, this will not update the `config/config.exs` file,
in order to make your changes persistent you will have to edit it manually.

# Defaults

By default the built-in cron service will auto-save the chain to disk every 15 minutes,
create a backup every day, and purge old backups every week (which are kept for 7 days by default)

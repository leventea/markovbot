import Config

alias MarkovBot.Scheduler.Tasks

config :nadia,
  token: "5109198901:AAEMNF94AqN5YEbe65kKL6trH3rnxsQySV4"

config :markov_bot,
  backup_dir: "./backups",
  autosave_path: "./state.chain",
  keep_backups_for: 7 # discard backups older than n days

config :markov_bot, MarkovBot.Scheduler,
  jobs: [
    # save the config chain state every 15 minutes
    { "*/15 * * * *", &Tasks.autosave/0 },
    { "@daily", &Tasks.backup/0 },
    { "@weekly", &Tasks.purge/0 }
  ]

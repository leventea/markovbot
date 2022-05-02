import Config

alias MarkovBot.Scheduler.Tasks

config :nadia,
  # string, the bot's token, can be obtained from @BotFather
  token: "5109198901:AAEMNF94AqN5YEbe65kKL6trH3rnxsQySV4"

config :markov_bot,
  log_ignored: false,                 # boolean, if set to true, it will log info related to ignored messages
                                      #          helpful if you can't figure out a chat's / user's ID
  backup_dir: "./backups",            # string, directory the backups get copied to
  autosave_path: "./state.chain",     # string, path the chain gets auto-saved to
  keep_backups_for: 7,                # integer, discard backups older than n days
  admins: [ 532217020, 1741227329 ],  # list of integers, people allowed to run admin-only commands
  chat_ids: [ -1001382033469, -1001415737136 ], # list of integers, the only chat(s) the bot trains on, responds to
  do_random_reply: fn ->              # function, must return bool, if it returns true the bot will reply to a message
    Enum.random(1..100) < 5
  end

config :markov_bot, MarkovBot.Scheduler,
  jobs: [
    # save the chain state every 15 minutes
    { "*/15 * * * *", &Tasks.autosave/0 },
    { "@daily", &Tasks.backup/0 },
    { "@weekly", &Tasks.purge/0 }
  ]

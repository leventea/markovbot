import Config

config :nadia,
  token: "5109198901:AAEMNF94AqN5YEbe65kKL6trH3rnxsQySV4"

config :markov_bot, MarkovBot.Scheduler,
  jobs: [
    # save the config chain state every 15 minutes
    { "*/15 * * * *", fn -> SentenceProvider.save_state(SentenceProvider, Path.absname("./state.chain")) end }
  ]

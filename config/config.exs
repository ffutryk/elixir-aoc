# Module from: https://github.com/mhanberg/advent-of-code-elixir-starter
# Author: Mitchell Hanberg

import Config

config :advent_of_code, Advent.Input,
  #allow_network?: true,
  session_cookie: System.get_env("ADVENT_OF_CODE_SESSION_COOKIE")

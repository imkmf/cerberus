use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :cerberus, Cerberus.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :cerberus, Cerberus.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "cerberus_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pbkdf2_rounds, 1

config :cerberus, :secret_key,
  "Z6cKz1yAzvsuSVCAZFxE5Af30kEXMUVi79poixJA/LRQtPipt02tZsx1cVAh2qKF"

defmodule Bank.Web.Router do
  use Plug.Router
  
  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
    pass: ["*/*"],
    json_decoder: Poison

  plug :match
  plug :dispatch

  get "/health" do
    send_resp(conn, 200, "ok")
  end

  forward "/graphiql",
    to: Absinthe.Plug.GraphiQL,
    init_opts: [schema: Bank.Web.GraphQL.Schema]
end

defmodule ScmpWeb.Contexts.User do
  def data() do
    Dataloader.Ecto.new(Scmp.Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end
end

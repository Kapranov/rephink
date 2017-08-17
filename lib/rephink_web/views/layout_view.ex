defmodule RephinkWeb.LayoutView do
  use RephinkWeb, :view

  def digest do
    manifest =
      Application.get_env(:rephink, Rephink.Endpoint, %{})[:cache_static_manifest]
      || "priv/static/cache_manifest.json"

    manifest_file = Application.app_dir(:rephink, manifest)

    if File.exists?(manifest_file) do
      manifest_file
      |> File.read!
    else
      %{}
    end
  end
end

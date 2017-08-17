Path.join(["rel", "rel/hooks", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    default_release: :default,
    default_environment: Mix.env()

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"&<Cb!Ahrp;rf88{hsNNpVLGdqhR39x%8q}~Je^Jw/ASXGAn:r)HTK3[RFp<c[,i4"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"SDIw$ZeI|Uy09g)EH/.&bTclAV,fYepIJ6_B?:37}g(9x3l[{v?BNi.QsGa!te]v"
  set pre_start_hook: "rel/hooks/pre_start"
  set post_start_hook: "rel/hooks/post_start"
end

release :rephink do
  set version: current_version(:rephink)
  set applications: [
    :runtime_tools
  ]
end


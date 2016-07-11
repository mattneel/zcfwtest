defmodule Fw.Mixfile do
  use Mix.Project

  @target System.get_env("NERVES_TARGET") || "bbb"

  def project do
    [app: :fw,
     version: "0.0.1",
     target: @target,
     archives: [nerves_bootstrap: "0.1.3"],
     deps_path: "deps/#{@target}",
     build_path: "_build/#{@target}",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps ++ system(@target)]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Fw, []},
     applications:
     [
       :logger,
       :nerves,
       :nerves_interim_wifi,
       :nerves_firmware_http,
       :db,
       :web
       ]
     ]
  end

  def deps do
    [
      {:nerves, "~> 0.3.0"},
      {:db, in_umbrella: true},
      {:web, in_umbrella: true},
      {:nerves_interim_wifi, "~> 0.0.2"},
      {:nerves_firmware_http, github: "nerves-project/nerves_firmware_http"},
    ]
  end

  def system(target) do
    [{:"nerves_system_#{target}", ">= 0.0.0"}]
  end

  def aliases do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end

end

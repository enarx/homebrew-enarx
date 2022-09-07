class Enarx < Formula
  desc "Confidential Computing with WASM"
  homepage "https://enarx.dev/"
  url "https://github.com/enarx/enarx.git",
    tag:      "v0.6.4",
    revision: "eff89e2aa738ee28744d3751f9ba1c71d26d66ec"
  license "Apache-2.0"
  head "https://github.com/enarx/enarx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rustup-init" => :build
  depends_on :macos

  def install
    system "#{Formula["rustup-init"].bin}/rustup-init", "-qy", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    # we are using nightly because Enarx requires nightly in order to build from source
    # pinning to nightly-2021-07-19 to avoid inconstency
    nightly_version = "nightly-2022-07-19"
    components = %w[rust-src miri clippy rustfmt]
    system "rustup", "toolchain", "install", nightly_version
    system "rustup", "component", "add", *components, "--toolchain", nightly_version
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "enarx", "platform", "info"
  end
end

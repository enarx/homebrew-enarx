class Enarx < Formula
  desc "Confidential Computing with WASM"
  homepage "https://enarx.dev/"
  url "https://github.com/enarx/enarx.git",
    tag:      "v0.5.1",
    revision: "31613bdb1b13887ac9c3f4770e0a46ba3ae17be4"
  license "Apache-2.0"
  head "https://github.com/enarx/enarx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/platten/enarx"
    sha256 cellar: :any_skip_relocation, big_sur:      "648938a358b1b2eb56077f13dbed774e318370e85a9b935281a8acf9c49203c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "862f9927ad0a3640af93dcf35a2a50cc63d6561d74959efb1ab7483ea136c286"
  end

  depends_on "rustup-init" => :build
  depends_on "rustup-init" => :test

  def install
    system "#{Formula["rustup-init"].bin}/rustup-init", "-qy", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    # we are using nightly because Enarx requires nightly in order to build from source
    # pinning to nightly-2021-05-03 to avoid inconstency
    nightly_version = "nightly-2022-05-03"
    components = %w[rust-src miri clippy rustfmt]
    system "rustup", "toolchain", "install", nightly_version
    system "rustup", "component", "add", *components, "--toolchain", nightly_version
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "enarx", "info"
  end
end

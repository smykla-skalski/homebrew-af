class Af < Formula
  desc "Afrael's CLI tool"
  homepage "https://github.com/smykla-skalski/af"
  url "https://github.com/smykla-skalski/af/archive/refs/tags/v0.8.109.tar.gz"
  sha256 "9bb41719943f8c8c9f539573c49b196c8c6b77a078599a71700260fd2db39801"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/smykla-skalski/af"
    sha256 cellar: :any,                 arm64_sequoia: "72d4da828ed17399c2fd4a3bb20f7876952ed703314c2ed486c4020d37dd0b8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7362e33b51091f59db880eaadeaabf77d58c0dbf22b4b8c1d2d3ddd766386633"
  end

  depends_on "rust" => :build
  depends_on "openssl"
  depends_on "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin / "af", "completions")

    system "cargo", "genman"
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/af --version")
  end
end

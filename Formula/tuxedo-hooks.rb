class TuxedoHooks < Formula
  desc "Keyboard-driven terminal UI and CLI for todo.txt with post-mutation hooks"
  homepage "https://github.com/nickfraser/tuxedo-hooks"
  url "https://github.com/nickfraser/tuxedo-hooks/releases/download/v2026.9.1/tuxedo-hooks-v2026.9.1-x86_64-unknown-linux-gnu.tar.gz"
  sha256 "3db1c1bf4698e619a9212c237b345103623d7c2ac3c23c9ea39a513fb0838364"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on arch: :x86_64
  depends_on :linux

  def install
    bin.install "tuxedo-hooks"
  end

  test do
    assert_match "tuxedo-hooks #{version}", shell_output("#{bin}/tuxedo-hooks --version")
  end
end

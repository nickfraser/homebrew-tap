class GitCredentialGopass < Formula
  desc "Git credential helper backed by gopass"
  homepage "https://github.com/gopasspw/git-credential-gopass"
  url "https://github.com/gopasspw/git-credential-gopass/releases/download/v1.17.2/git-credential-gopass-1.17.2-linux-amd64.tar.gz"
  sha256 "d768a63b5eeb5ec3818432031430bb1f9626affd761fb8675c31f79b184135e0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on arch: :x86_64
  depends_on "gnupg"
  depends_on :linux

  def install
    bin.install "git-credential-gopass"
  end

  def caveats
    <<~EOS
      Initialize and configure a gopass password store before using this helper.
      Then enable it for Git with:
        git-credential-gopass configure --global
    EOS
  end

  test do
    assert_path_exists bin/"git-credential-gopass"
  end
end

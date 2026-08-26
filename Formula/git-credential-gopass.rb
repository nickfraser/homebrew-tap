class GitCredentialGopass < Formula
  desc "Git credential helper backed by gopass"
  homepage "https://github.com/gopasspw/git-credential-gopass"
  url "https://github.com/gopasspw/git-credential-gopass/releases/download/v1.16.1/git-credential-gopass-1.16.1-linux-amd64.tar.gz"
  sha256 "164e87faa15b83b6c9692b0624268b0ea6ae58fe57d163cd5862c171fb8762b5"
  license "MIT"

  depends_on :linux
  depends_on arch: :x86_64
  depends_on "git"
  depends_on "gnupg"

  livecheck do
    url :stable
    strategy :github_latest
  end

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
    assert_match version.to_s, shell_output("#{bin}/git-credential-gopass version")

    system bin/"git-credential-gopass", "configure", "--global"
    git = formula_opt_bin("git")/"git"
    assert_equal "gopass", shell_output("#{git} config --global --get credential.helper").strip
  end
end

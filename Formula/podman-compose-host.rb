class PodmanComposeHost < Formula
  include Language::Python::Virtualenv

  desc "Compose implementation with an externally managed Podman"
  homepage "https://github.com/containers/podman-compose"
  url "https://files.pythonhosted.org/packages/1f/80/a6ada19562b12ed466dac5c3e02aef5ed7c8d0881864d80e0d94d0dc71f5/podman_compose-1.6.0.tar.gz"
  sha256 "c83fd9bcbaa635100d581ce52a7a4b712ee0d457481232aff392efe3ebc5a217"
  license "GPL-2.0-only"

  depends_on :linux
  depends_on arch: :x86_64
  depends_on "libyaml"
  depends_on "python@3.14"

  conflicts_with "podman-compose", because: "both install a podman-compose executable"

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      This formula does not install Podman. Provide a compatible podman executable
      on PATH through your operating system or another package manager.
    EOS
  end

  test do
    podman = testpath/"podman"
    log = testpath/"podman.log"
    podman.write <<~SH
      #!/bin/sh
      printf '%s\n' "$*" >> "$PODMAN_LOG"
      case "$1" in
        --version)
          printf '%s\n' 'podman version 5.0.0'
          ;;
        ps)
          printf '%s\n' '[]'
          ;;
      esac
    SH
    podman.chmod 0755

    ENV["PODMAN_LOG"] = log.to_s
    ENV.prepend_path "PATH", testpath

    (testpath/"compose.yml").write <<~YAML
      services:
        test:
          image: busybox:latest
    YAML

    system bin/"podman-compose", "up", "--pull", "never", "--no-start"

    assert_path_exists log
    commands = log.read
    assert_match(/^--version$/, commands)
    assert_match(/^ps\b/, commands)
    assert_match(/^create\b/, commands)
  end
end

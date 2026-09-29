class Flameshot < Formula
  desc "Screenshot software with built-in annotation tools"
  homepage "https://flameshot.org/"
  url "https://github.com/flameshot-org/flameshot/archive/refs/tags/v14.0.0.tar.gz"
  sha256 "810c399f3b9fbfd72e24e61417ede24243925f9c0d03040a8aba0d4866676d93"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "qttools" => :build
  depends_on arch: :x86_64
  depends_on :linux
  depends_on "mesa"
  depends_on "qtbase"
  depends_on "qtsvg"
  depends_on "qtwayland"

  resource "kdsingleapplication" do
    url "https://github.com/KDAB/KDSingleApplication/archive/refs/tags/v1.2.0.tar.gz"
    sha256 "ff4ae6a4620beed1cdb3e6a9b78a17d7d1dae7139c3d4746d4856b7547d42c38"
  end

  resource "qt-color-widgets" do
    url "https://gitlab.com/mattbas/Qt-Color-Widgets/-/archive/5d52e907e50dc88cf969b41cea44665ff6c475b1/Qt-Color-Widgets-5d52e907e50dc88cf969b41cea44665ff6c475b1.tar.gz"
    sha256 "99edd39dca0367b1cfd388bf031c4915137580bd73f87c65f7720b8a4af14efa"
  end

  def install
    resource("kdsingleapplication").stage buildpath/"external/KDSingleApplication"
    resource("qt-color-widgets").stage buildpath/"external/Qt-Color-Widgets"

    args = %w[
      -DDISABLE_UPDATE_CHECKER=ON
      -DUSE_LAUNCHER_ABSOLUTE_PATH=OFF
      -S
      .
      -B
      build
    ]

    system "cmake", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    rm_r include
    rm_r lib

    inreplace share/"applications/org.flameshot.Flameshot.desktop",
              "Exec=flameshot", "Exec=#{opt_bin}/flameshot"
    inreplace share/"dbus-1/services/org.flameshot.Flameshot.service",
              "Exec=#{bin}/flameshot", "Exec=#{opt_bin}/flameshot"
  end

  def caveats
    <<~EOS
      Flameshot requires a graphical desktop session and D-Bus. On Wayland,
      provide xdg-desktop-portal and the backend for your desktop environment.
      Ensure #{HOMEBREW_PREFIX}/share is included in XDG_DATA_DIRS for desktop
      launcher discovery.
    EOS
  end

  test do
    ENV["QT_QPA_PLATFORM"] = "offscreen"
    assert_match version.to_s, shell_output("#{bin}/flameshot --version")

    desktop_commands = (share/"applications/org.flameshot.Flameshot.desktop")
                       .read.lines.grep(/^Exec=/).map(&:chomp)
    assert_equal [
      "Exec=#{opt_bin}/flameshot",
      "Exec=#{opt_bin}/flameshot config",
      "Exec=#{opt_bin}/flameshot gui",
      "Exec=#{opt_bin}/flameshot launcher",
    ], desktop_commands

    service = (share/"dbus-1/services/org.flameshot.Flameshot.service").read
    assert_match "Exec=#{opt_bin}/flameshot", service
  end
end

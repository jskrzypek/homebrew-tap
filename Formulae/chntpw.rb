class Chntpw < Formula
  desc "The Offline NT Password Editor"
  homepage "https://github.com/Tody-Guo/chntpw"
  url "https://github.com/jskrzypek/chntpw/archive/0.99.6-openssl@1.1.tar.gz"
  sha256 "83fca384a76ee3330d6b5f43caa7a5a9f9319f5da41b507caa961bc62ff0917c"
  head "https://github.com/jsrkrzypek/chntpw.git"

  depends_on "openssl"

  def install
    if Hardware::CPU.arm?
      # Homebrew on M1 appears to install here instead of /usr/local/opt
      system "make", "dynamic-only", "OSSLPATH=#{HOMEBREW_PREFIX}/opt/openssl"
    else
      system "make", "dynamic-only"
    end
    # system "make", "dynamic-only"
    bin.install "chntpw"
  end

  test do
    assert_match "chntpw version 0.99.6 080526 (sixtyfour)", shell_output("#{bin}/chntpw -h")
  end
end

class Docopts < Formula
  desc "Shell interpreter for docopt, the command-line interface description language"
  homepage "https://github.com/docopt/docopts"
  url "https://github.com/docopt/docopts/archive/v0.6.4-with-no-mangle-double-dash.tar.gz"
  sha256 "5bf29a4eaa07cb3d1449077697d8746678cc490ee3e63cfe3e1025cebf2f4008"
  head "https://github.com/docopt/docopts.git", branch: "master"
  license "MIT"

  depends_on "go" => :build

  def install
    # go mod init + go get b/c 0.6.4 doesn't use Go modules yet (see also my PR: https://github.com/docopt/docopts/pull/65)
    system "go", "mod", "init", "github.com/docopt/docopts"
    system "go", "get", "github.com/docopt/docopt-go"
    system "go", "build", "docopts.go"
    bin.install "docopts" # no bottle yet as this a third-party tap
    bin.install "docopts.sh" # helper functions, meant to be used in a script with `source docopts.sh`
  end

  test do
    assert_match "Shell interface for docopt, the CLI description language.", shell_output("#{bin}/docopts -h")
  end
end

class Coder < Formula
  desc "Remote development environments on your infrastructure provisioned with Terraform"
  homepage "https://github.com/coder/coder"
  version "0.9.10"
  url "https://github.com/coder/coder.git", tag: "v#{version}"
  head "https://github.com/coder/coder.git", branch: "main"
  license "AGPL-3.0"
 
  if OS.mac?
    os = "darwin"
    archive = "zip"
    if Hardware::CPU.intel?
      arch = "amd64"
      sha256 "aed7973e74047539d901efed3798054b6f81870190f177fa66934a44f4b50f96"
    elsif Hardware::CPU.arm?
      arch = "arm64"
      sha256 "16c1b1eb3daefaefdff512cb932c478a72ab94fbcdaa3e394d7df340e1e9ba2d"
    end
  elsif OS.linux?
    os = "linux"
    archive = "tar.gz"
    if Hardware::CPU.intel?
      arch "amd64"
      sha256 "448b3b770f77e8e66807534d5ca077d7ac1d771fe872e5ecf9d8629a900c1c52"
    elsif Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      arch = "arm64"
      sha256 "6cdfbcb343ab91e21489e4237456d8875ce3ed67819fa4f14d6d5b972025723d"
    elsif Hardware::CPU.arm? && !Hardware::CPU.is_64_bit?
      arch = "armv7"
      sha256 "c5b6158ddd94c99bd4a9ba63e13ec760bf8bbb7d3062d7cc16d0b36c4fa307f9"
    end
  end

  depends_on "go" => :build
  depends_on "bash" => :build
  depends_on "make" => :build
  depends_on "gnu-getopt" => :build

  def install
    ENV.prepend_path "PATH", bin.to_s
    ENV.prepend_path "PATH", Formula["make"].opt_libexec/"gnubin"
    ENV.prepend_path "PATH", Formula["gnu-getopt"].opt_bin
    ENV.prepend_path "PATH", Formula["bash"].opt_bin
    ENV.prepend_path "PATH", Formula["go"].opt_bin
    system buildpath/"scripts/build_go.sh",
      "--arch", (
        Hardware::CPU.intel? ? 
        "amd64" : 
        (OS.mac? || Hardware::CPU.is_64_bit?) ? "arm64" : "armv7"
      ),
      "--os", OS.mac? ? "darwin" : "linux",
      "--version", %x|bash #{buildpath}/scripts/version.sh|,
      "--output", buildpath/"coder"
    bin.install buildpath/"coder"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/coder -v")
  end
end

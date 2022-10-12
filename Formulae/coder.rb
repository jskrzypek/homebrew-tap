class Coder < Formula
  desc "Remote development environments on your infrastructure provisioned with Terraform"
  homepage "https://github.com/coder/coder"
  head "https://github.com/coder/coder.git", branch: "main"
  license "AGPL-3.0"
  version "0.9.10"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/coder/coder/releases/download/v#{version}/coder_#{version}_darwin_amd64.zip"
    sha256 "aed7973e74047539d901efed3798054b6f81870190f177fa66934a44f4b50f96"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/coder/coder/releases/download/v#{version}/coder_#{version}_darwin_arm64.zip"
    sha256 "16c1b1eb3daefaefdff512cb932c478a72ab94fbcdaa3e394d7df340e1e9ba2d"
  end
  
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/coder/coder/releases/download/v#{version}/coder_#{version}_linux_amd64.tar.gz"
    sha256 "448b3b770f77e8e66807534d5ca077d7ac1d771fe872e5ecf9d8629a900c1c52"
  end
  
  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url "https://github.com/coder/coder/releases/download/v#{version}/coder_#{version}_linux_arm64.tar.gz"
    sha256 "6cdfbcb343ab91e21489e4237456d8875ce3ed67819fa4f14d6d5b972025723d"
  end

  if OS.linux? && Hardware::CPU.arm? && !Hardware::CPU.is_64_bit?
    url "https://github.com/coder/coder/releases/download/v#{version}/coder_#{version}_linux_armv7.tar.gz"
    sha256 "c5b6158ddd94c99bd4a9ba63e13ec760bf8bbb7d3062d7cc16d0b36c4fa307f9"
  end
  
  if build.head?
    depends_on "go" => :build
    depends_on "make" => :build
    depends_on "protoc-gen-go" => :build
  end
  
  def install
    if build.head?
      ENV["GOPATH"] = buildpath
      ENV["GO111MODULE"] = "auto"
      system "go", "install", "protoc-gen-go-drpc"
      system "make", "install"
      bin.install "coder"
    else
      bin.install "coder"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/coder -v")
  end
end

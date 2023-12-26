class Nuget < Formula
  desc "Package manager for Microsoft development platform including .NET"
  homepage "https://www.nuget.org/"
  url "https://dist.nuget.org/win-x86-commandline/v6.8.0/nuget.exe" # make sure libexec.install below matches case
  sha256 "6c9e1b09f06971933b08080e7272a2ca5b0d8222500744da757bd8d019013a3d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33976e7a035a8769424068063bc0e597b84489b0907d1a6c592ca7a020ebb685"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33976e7a035a8769424068063bc0e597b84489b0907d1a6c592ca7a020ebb685"
    sha256 cellar: :any_skip_relocation, sonoma:         "33976e7a035a8769424068063bc0e597b84489b0907d1a6c592ca7a020ebb685"
    sha256 cellar: :any_skip_relocation, ventura:        "33976e7a035a8769424068063bc0e597b84489b0907d1a6c592ca7a020ebb685"
    sha256 cellar: :any_skip_relocation, monterey:       "33976e7a035a8769424068063bc0e597b84489b0907d1a6c592ca7a020ebb685"
    sha256 cellar: :any_skip_relocation, big_sur:        "33976e7a035a8769424068063bc0e597b84489b0907d1a6c592ca7a020ebb685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22a91716384fc612275395eaaa396657efeeb7038a41b136d6de46f7664f5dd8"
  end

  deprecate! date: "2023-10-24", because: "uses deprecated `mono`"

  depends_on "mono"

  def install
    libexec.install "nuget.exe" => "nuget.exe"
    (bin/"nuget").write <<~EOS
      #!/bin/bash
      mono #{libexec}/nuget.exe "$@"
    EOS
  end

  test do
    assert_match "NuGet.Protocol.Core.v3", shell_output("#{bin}/nuget list packageid:NuGet.Protocol.Core.v3")
  end
end

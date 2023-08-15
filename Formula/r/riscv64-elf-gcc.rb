class Riscv64ElfGcc < Formula
  desc "GNU compiler collection for riscv64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
  sha256 "e275e76442a6067341a27f04c5c6b83d8613144004c0413528863dc6b5c743da"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "riscv64-elf-binutils"

  # Fixes std::log2 import from math.h on Big Sur and Monterey.
  # Already included upstream for next release. Remove on next release.
  # gcc/config/riscv/genrvv-type-indexer.cc:118:30: error: no member named 'log2' in namespace 'std';
  patch do
    url "https://gcc.gnu.org/git/?p=gcc.git;a=patch;h=87c347c2897537a6aa391efbfc5ed00c625434fe"
    sha256 "470f9cd51f0ad5d6b7b8dc080f3d4830a8ae640257ed6fccc61bd46287798eb0"
  end

  def install
    target = "riscv64-elf"
    mkdir "riscv64-elf-gcc-build" do
      system "../configure", "--target=#{target}",
                             "--prefix=#{prefix}",
                             "--infodir=#{info}/#{target}",
                             "--disable-nls",
                             "--without-isl",
                             "--without-headers",
                             "--with-as=#{Formula["riscv64-elf-binutils"].bin}/riscv64-elf-as",
                             "--with-ld=#{Formula["riscv64-elf-binutils"].bin}/riscv64-elf-ld",
                             "--enable-languages=c,c++"
      system "make", "all-gcc"
      system "make", "install-gcc"
      system "make", "all-target-libgcc"
      system "make", "install-target-libgcc"

      # FSF-related man pages may conflict with native gcc
      (share/"man/man7").rmtree
    end
  end

  test do
    (testpath/"test-c.c").write <<~EOS
      int main(void)
      {
        int i=0;
        while(i<10) i++;
        return i;
      }
    EOS
    system "#{bin}/riscv64-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    assert_match "file format elf64-littleriscv",
                 shell_output("#{Formula["riscv64-elf-binutils"].bin}/riscv64-elf-objdump -a test-c.o")
  end
end

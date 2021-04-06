with import <nixpkgs> {};
let
  my-python-packages = python-packages: with python-packages; [
#    numpy
  ]; 
  python-with-my-packages = python3.withPackages my-python-packages;
  my-python-packages-deps = [
#    zlib
#    tk
#    tcl
  ];
  R-with-my-packages = rWrapper.override{ packages = with rPackages; [ ggplot2 dplyr xts rbenchmark ]; };
  sc-benchmark = stdenv.mkDerivation {
    name = "sc-benchmark";
    
    #buildInputs = [ git ];
    
    src = builtins.fetchGit {
      rev = "23898d7168d3e51b750fc21951fdfb874ded8d02";
      url = "https://github.com/FredHutch/sc-benchmark.git";
      ref = "master";
    };
    #src = builtins.fetchFromGitHub {
    #  owner = "FrankHutch";
    #  repo = "sc-benchmark";
    #  rev = "23898d7168d3e51b750fc21951fdfb874ded8d02";
    #  sha256 = "";
    #};
    phases = "unpackPhase installPhase";
    
    installPhase = ''
      mkdir -p $out/
      pwd
      echo "CHECKING CONTENTS:"
      ls -la
      mv ./* $out/
    '';
  };
in
stdenv.mkDerivation {
  name = "sc-benchmarkEnv";
  buildInputs = [
    nix
    bash
    vim
    gdb
    git
    
    # Dependencies
    my-python-packages-deps
    python-with-my-packages
    binutils
    gfortran
    openblas
    tk
    bzip2
    pcre2
    tcl
    zlib
    R-with-my-packages
    
    # Benchmarking
    sc-benchmark
    
  ];
  src = null;
}
#  shellHook = ''
#    export LANG=en_US.UTF-8
#    ln -sfn ${osu-micro-benchmarks.out}/bin/* /usr/bin
#  '';

with import <nixpkgs> { };
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
#  R-with-my-packages = rWrapper.override{ packages = with rPackages; [ ggplot2 dplyr xts rbenchmark ]; };
in
{ PerfZeroProdEnv = buildEnv {
  name = "PerfZero-prod-env";
  paths = [
    # Always include nix, or environment will break
    # Include bash for base OSes without bash
    nix
    bash
    git
    
    # Dependencies
    my-python-packages-deps
    python-with-my-packages
    binutils
    gfortran
#    openblas
#    tk
#    bzip2
#    pcre2
#    tcl
#    zlib
#    R-with-my-packages
    cudaPackages.cudatoolkit_10
    
    # Benchmark
    
    ];
  };
}


with import <nixpkgs> {};
let
  my-python-packages = python-packages: with python-packages; [
    numpy
  ]; 
  python-with-my-packages = python3.withPackages my-python-packages;
  my-python-packages-deps = [
#    zlib
    tk
#    tcl
  ];
in
stdenv.mkDerivation {
  name = "PerfZeroDevEnv";
  buildInputs = [
    nix
    bash
    vim
    gdb
    git
    htop

    # Dependencies
    my-python-packages-deps
    python-with-my-packages
    binutils
    gfortran
    openblas
    cudaPackages.cudatoolkit_10
    cudnn
    hdf5
    libpng
    freetype
    # zmq3?
    pkg-config
#    unzip
#    curl
    #libnvinfer5?
    lsb-release
#    wget
#    zip
    google-cloud-sdk
 
    
    # Benchmarking
    
  ];
  src = null;
}
#  shellHook = ''
#    export LANG=en_US.UTF-8
#    ln -sfn ${osu-micro-benchmarks.out}/bin/* /usr/bin
#  '';

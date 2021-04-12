with import <nixpkgs> {};
let
  my-python-packages = python-packages: with python-packages; [
    #requests
    absl-py
    scikitlearn
    six
    google_api_python_client
    google_cloud_bigquery
    kaggle
    numpy
    oauth2client
    pandas
    psutil
    py-cpuinfo
    scipy
    tensorflow-hub
    tensorflow-model-optimization
    tensorflow-datasets
    tensorflow-addons
    dataclasses
    gin-config
    tf_slim
    Cython
    matplotlib
    pyyaml
    # CV related dependencies
    opencv-python-headless
    Pillow
    pycocotools
    # NLP related dependencies
    seqeval
    sentencepiece
    sacrebleu
  ];
  python-with-my-packages = python3.withPackages my-python-packages;
  my-python-packages-deps = [
#    zlib
    tk
#    tcl
  ];
  perfzero-benchmark = stdenv.mkDerivation {
    name = "perfzero-benchmark";

    src = builtins.fetchGit {
      rev = "318695fb08623996c33648c0997d6bf15a67de6e";
      url = "https://github.com/tensorflow/benchmarks.git";
      ref = "master";

    };
    phases = "unpackPhase installPhase";

    installPhase = ''
      mkdir -p $out/
#      pwd
#      echo "CHECKING CONTENTS:"
#      ls -la
      mv ./* $out/
    '';
  };
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
    unzip
#    curl
    #libnvinfer5?
    lsb-release
#    wget
#    zip
    google-cloud-sdk


    # Benchmarking
    perfzero-benchmark

  ];
  src = null;
  shellHook = ''
    export LANG=en_US.UTF-8
    ln -sfn ${perfzero-benchmark.out} /usr/local/perfzero-benchmark
  '';
}


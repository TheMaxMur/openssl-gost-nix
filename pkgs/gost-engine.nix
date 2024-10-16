{ stdenv
, fetchFromGitHub
, cmake
, openssl_3_3
}:

stdenv.mkDerivation rec {
  name = "openssl-engine-gost";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "gost-engine";
    repo = "engine";
    rev = "v${version}";
    hash = "sha256-52nt0TtPDpMjC0QCTrWYUhpHXZNCDrds0LrkQdDN1Mo=";
    fetchSubmodules = true;
  };

  outputs = [ "out" "bin" ];
  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl_3_3 ];
  
  cmakeFlags = [
    "-DOPENSSL_ENGINES_DIR=bin/"
  ];

  installPhase = ''
    # Shared library
    mkdir -p "$out"/lib/engines-3
    mkdir -p "$bin"/lib/engines-3
    install -m444 bin/gost.so "$out"/lib/engines-3/gost.so
    install -m444 bin/gost.so "$bin"/lib/engines-3/gost.so

    # Binary
    mkdir -p "$bin"/bin
    install -m755 bin/gostsum "$bin"/bin/gostsum
    install -m755 bin/gost12sum "$bin"/bin/gost12sum
  '';
}


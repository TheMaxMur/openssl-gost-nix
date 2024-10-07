{ stdenv
, fetchgit
, cmake
, openssl_3_3
}:

stdenv.mkDerivation rec {
  name = "openssl-engine-gost";
  version = "3.0.3";

  src = fetchgit {
    url = "https://github.com/gost-engine/engine";
    rev = "refs/tags/v${version}";
    hash = "sha256-52nt0TtPDpMjC0QCTrWYUhpHXZNCDrds0LrkQdDN1Mo=";
  };

  outputs = [ "out" "bin" ];
  nativeBuildInputs = [ cmake openssl_3_3 ];
  
  cmakeFlags = [
    "-DOPENSSL_ENGINES_DIR=bin/"
  ];


  installPhase = ''
    mkdir -p "$out"/etc/ssl
    # install -m444 openssl.cnf "$out"/etc/ssl/openssl.cnf
    # install -m444 openssl.cnf "$out"/etc/ssl/openssl.cnf.dist

    # Builded directory above current
    cd ..

    # Shared library
    mkdir -p "$out"/lib/engines-3
    mkdir -p "$bin"/lib/engines-3
    install -m444 build/bin/gost.so "$out"/lib/engines-3/gost.so
    install -m444 build/bin/gost.so "$bin"/lib/engines-3/gost.so

    # Binary
    mkdir -p "$bin"/bin
    install -m755 build/bin/gostsum "$bin"/bin/gostsum
    install -m755 build/bin/gost12sum "$bin"/bin/gost12sum
  '';
}


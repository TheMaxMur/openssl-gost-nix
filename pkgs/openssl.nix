{ lib
, openssl_3_3
, fetchFromGitHub
, openssl-gost-engine
}:

openssl_3_3.overrideAttrs (old: {
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "openssl";
    repo = "openssl";
    rev = "refs/tags/openssl-3.3.2";
    hash = "sha256-3KB0fetgXloCniFsvzzuchKgopPdQdh9/00M1mqJWyg=";
  };

  buildInputs = (old.buildInputs or [])
    ++ [ openssl-gost-engine ];

  patches = builtins.filter (patch: !lib.hasSuffix "3.3/CVE-2024-5535.patch" (builtins.toString patch)) old.patches;

  postInstall = (old.postInstall or '''') + ''
    cp ${openssl-gost-engine}/lib/engines-3/gost.so $out/lib/engines-3/gost.so
    chmod 555 $out/lib/engines-3/gost.so

    # echo 'openssl_conf = openssl_def' | 
    cp ${openssl_3_3.out}/etc/ssl/openssl.cnf openssl.cnf
    chmod +w openssl.cnf
    sed -i "s/openssl_init/openssl_def/" openssl.cnf
    cat >> openssl.cnf <<EOF
    [openssl_def]
    engines = engine_section

    [engine_section]
    gost = gost_section

    [gost_section]
    engine_id = gost
    dynamic_path = $out/lib/engines-3/gost.so
    default_algorithms = ALL
    CRYPT_PARAMS = id-Gost28147-89-CryptoPro-A-ParamSet
    EOF
    cp openssl.cnf $out/etc/ssl/openssl.cnf
  '';
})


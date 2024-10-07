{ curl
, openssl
}:

curl.override {
  opensslSupport = true;
  inherit openssl;
}


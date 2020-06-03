{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "act";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "v${version}";
    sha256 = "17w7pqpn9pkzc85lrsmyhxy6rip47dxw1hkz4ml3y5n68nysfpb9";
  };

  modSha256 = "1bdczh9hzkrs6xb2m2aag674m1dc572pd5iplvr3rkf2a45dmqac";

  meta = with lib; {
    description = "Run your GitHub Actions locally";
    homepage = "https://circleci.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}

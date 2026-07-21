package br.gov.mg.probpms.identity.application;

import com.auth0.jwk.Jwk;
import com.auth0.jwk.JwkProvider;
import com.auth0.jwk.JwkProviderBuilder;
import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import java.net.URI;
import java.security.interfaces.RSAPublicKey;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

/**
 * JWT validation service for Supabase tokens.
 * Only validates Supabase-issued JWTs via JWKS endpoint.
 * Token issuance is exclusively handled by Supabase.
 */
@Service
public class JwtService {
  private final String issuer;
  private final long ttlSeconds;
  private final JwkProvider jwkProvider;

  public JwtService(
      @Value("${security.jwt.jwks-url:https://cyolmcowhfhymemmxgrn.supabase.co/auth/v1/.well-known/jwks.json}") String jwksUrl,
      @Value("${security.jwt.issuer:https://cyolmcowhfhymemmxgrn.supabase.co/auth/v1}") String issuer,
      @Value("${security.jwt.ttl-seconds:3600}") long ttlSeconds) throws Exception {
    this.issuer = issuer;
    this.ttlSeconds = ttlSeconds;
    this.jwkProvider = new JwkProviderBuilder(URI.create(jwksUrl).toURL()).cached(true).build();
  }

  public DecodedJWT verify(String token) throws com.auth0.jwt.exceptions.JWTVerificationException {
    var decoded = JWT.decode(token);
    Jwk jwk = resolveJwk(decoded);
    Algorithm algorithm = Algorithm.RSA256((RSAPublicKey) jwk.getPublicKey(), null);
    return JWT.require(algorithm).acceptLeeway(60).build().verify(token);
  }

  public long ttlSeconds() {
    return ttlSeconds;
  }

  private Jwk resolveJwk(DecodedJWT decoded) throws Exception {
    String kid = decoded.getKeyId();
    if (kid != null && !kid.isBlank()) {
      return jwkProvider.get(kid);
    }
    return jwkProvider.getAll().stream().findFirst()
        .orElseThrow(() -> new IllegalStateException("Nenhuma chave JWKS disponível"));
  }
}

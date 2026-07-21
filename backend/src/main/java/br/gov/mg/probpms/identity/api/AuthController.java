package br.gov.mg.probpms.identity.api;

import br.gov.mg.probpms.identity.application.SupabaseAuthService;
import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {
  private final SupabaseAuthService supabaseAuth;

  public AuthController(SupabaseAuthService supabaseAuth) {
    this.supabaseAuth = supabaseAuth;
  }

  @PostMapping("/login")
  public ResponseEntity<LoginResponse> login(@RequestBody @jakarta.validation.Valid LoginRequest request) {
    Map<String, Object> payload = supabaseAuth.signIn(request.email(), request.password());
    Object token = payload.get("access_token");
    if (!(token instanceof String accessToken) || accessToken.isBlank()) {
      throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Credenciais inválidas");
    }
    Object expiresIn = payload.get("expires_in");
    long ttlSeconds = expiresIn instanceof Number number ? number.longValue() : 3600L;
    return ResponseEntity.ok(new LoginResponse(accessToken, "Bearer", ttlSeconds));
  }
}

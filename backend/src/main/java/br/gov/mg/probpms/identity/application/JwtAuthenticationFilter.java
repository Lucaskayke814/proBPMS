package br.gov.mg.probpms.identity.application;

import br.gov.mg.probpms.identity.domain.UserRole;
import com.auth0.jwt.exceptions.JWTVerificationException;
import com.auth0.jwt.interfaces.DecodedJWT;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {
  private final JwtService jwt;

  public JwtAuthenticationFilter(JwtService jwt) {
    this.jwt = jwt;
  }

  @Override
  protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
      throws ServletException, IOException {
    var header = request.getHeader("Authorization");
    if (header != null && header.startsWith("Bearer ")
        && SecurityContextHolder.getContext().getAuthentication() == null) {
      try {
        var token = jwt.verify(header.substring(7));
        var role = resolveRole(token);
        var authority = new SimpleGrantedAuthority("ROLE_" + role.name());
        var principal = token.getClaim("email").asString();
        if (principal == null || principal.isBlank()) {
          principal = token.getSubject();
        }
        SecurityContextHolder.getContext().setAuthentication(
            new UsernamePasswordAuthenticationToken(principal, null, List.of(authority)));
      } catch (JWTVerificationException | IllegalArgumentException ignored) {
      }
    }
    chain.doFilter(request, response);
  }

  private UserRole resolveRole(DecodedJWT token) {
    var directRole = token.getClaim("role").asString();
    if (directRole != null && !directRole.isBlank()) {
      return parseRole(directRole);
    }

    var metadata = token.getClaim("app_metadata").asMap();
    Object appRole = metadata != null ? metadata.get("role") : null;
    if (appRole instanceof String appRoleValue && !appRoleValue.isBlank()) {
      return parseRole(appRoleValue);
    }

    var userMetadata = token.getClaim("user_metadata").asMap();
    Object userRole = userMetadata != null ? userMetadata.get("role") : null;
    if (userRole instanceof String userRoleValue && !userRoleValue.isBlank()) {
      return parseRole(userRoleValue);
    }

    return UserRole.GESTOR_CENTRAL;
  }

  private UserRole parseRole(String value) {
    try {
      return UserRole.valueOf(value.trim().toUpperCase(Locale.ROOT));
    } catch (IllegalArgumentException ex) {
      return UserRole.GESTOR_CENTRAL;
    }
  }
}

package br.gov.mg.probpms.identity.application;

import br.gov.mg.probpms.identity.domain.UserRole;
import br.gov.mg.probpms.identity.infra.AppUser;
import br.gov.mg.probpms.identity.infra.AppUserRepository;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
public class BootstrapAdminConfiguration {
  @Bean
  CommandLineRunner bootstrapAdmin(AppUserRepository users, PasswordEncoder encoder,
      @Value("${bootstrap.admin.email:}") String email,
      @Value("${bootstrap.admin.password:}") String password) {
    return args -> {
      if (!email.isBlank() && !password.isBlank() && users.findByEmailIgnoreCaseAndActiveTrue(email).isEmpty()) {
        users.save(new AppUser(UUID.randomUUID(), "Administrador Inicial", email, encoder.encode(password), UserRole.GESTOR_CENTRAL));
      }
    };
  }
}

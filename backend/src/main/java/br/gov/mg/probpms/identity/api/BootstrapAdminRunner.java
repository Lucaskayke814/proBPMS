package br.gov.mg.probpms.identity.api;

import br.gov.mg.probpms.identity.domain.UserRole;
import br.gov.mg.probpms.identity.infra.AppUser;
import br.gov.mg.probpms.identity.infra.AppUserRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import java.util.UUID;

@Component
public class BootstrapAdminRunner implements CommandLineRunner {
    private final AppUserRepository users;
    private final PasswordEncoder passwords;
    private final String email;
    private final String password;

    public BootstrapAdminRunner(AppUserRepository users, PasswordEncoder passwords,
            @Value("${bootstrap.admin.email:}") String email,
            @Value("${bootstrap.admin.password:}") String password) {
        this.users = users;
        this.passwords = passwords;
        this.email = email;
        this.password = password;
    }

    @Override
    public void run(String... args) {
        if (email == null || email.isBlank() || password == null || password.isBlank())
            return;
        if (users.findByEmailIgnoreCaseAndActiveTrue(email).isPresent())
            return;
        users.save(new AppUser(UUID.randomUUID(), "Gestor Central", email, passwords.encode(password),
                UserRole.GESTOR_CENTRAL));
    }
}

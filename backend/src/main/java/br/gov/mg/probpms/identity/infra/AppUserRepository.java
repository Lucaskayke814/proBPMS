package br.gov.mg.probpms.identity.infra;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AppUserRepository extends JpaRepository<AppUser, java.util.UUID> {
  Optional<AppUser> findByEmailIgnoreCaseAndActiveTrue(String email);
}

package br.gov.mg.probpms.identity.infra;

import br.gov.mg.probpms.identity.domain.UserRole;
import jakarta.persistence.*;
import java.util.UUID;

@Entity
@Table(name = "app_user")
public class AppUser {
  @Id private UUID id;
  @Column(name = "full_name", nullable = false) private String fullName;
  @Column(nullable = false, unique = true) private String email;
  @Column(name = "password_hash", nullable = false) private String passwordHash;
  @Enumerated(EnumType.STRING) @Column(nullable = false) private UserRole role;
  @Column(nullable = false) private boolean active;
  protected AppUser() { }
  public AppUser(UUID id, String fullName, String email, String passwordHash, UserRole role) {
    this.id = id; this.fullName = fullName; this.email = email; this.passwordHash = passwordHash; this.role = role; this.active = true;
  }
  public UUID getId() { return id; } public String getEmail() { return email; } public String getPasswordHash() { return passwordHash; }
  public UserRole getRole() { return role; } public boolean isActive() { return active; }
}

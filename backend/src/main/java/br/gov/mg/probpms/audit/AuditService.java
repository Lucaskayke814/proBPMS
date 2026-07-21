package br.gov.mg.probpms.audit;

import java.util.UUID;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class AuditService {
  private final JdbcTemplate jdbc;
  public AuditService(JdbcTemplate jdbc) { this.jdbc = jdbc; }
  public void created(String entityType, UUID entityId, String actor, String details) {
    jdbc.update("INSERT INTO audit_event (id, entity_type, entity_id, action, actor_name, details) VALUES (?, ?, ?, 'CREATED', ?, CAST(? AS jsonb))",
        UUID.randomUUID(), entityType, entityId, actor, details);
  }
}

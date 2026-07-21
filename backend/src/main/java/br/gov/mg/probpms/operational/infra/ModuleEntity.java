package br.gov.mg.probpms.operational.infra;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "new_module")
public class ModuleEntity {
  @Id private UUID id;
  @Column(nullable = false) private String name;
  @Column(nullable = false, columnDefinition = "text") private String description;
  @Column(name = "agency_id", nullable = false) private UUID agencyId;
  @Column(columnDefinition = "text") private String objective;
  @Column(columnDefinition = "text") private String scope;
  @Column(name = "expected_value", nullable = false) private BigDecimal expectedValue;
  @Column(name = "estimated_hours") private BigDecimal estimatedHours;
  @Column(name = "schedule_text", columnDefinition = "text") private String scheduleText;
  @Column(nullable = false) private String status;
  @Column(columnDefinition = "text") private String documents;
  @Column(name = "created_at", nullable = false) private Instant createdAt;
  @Column(name = "updated_at", nullable = false) private Instant updatedAt;

  protected ModuleEntity() {}

  public ModuleEntity(UUID id, String name, String description, UUID agencyId, String objective, String scope, BigDecimal expectedValue, BigDecimal estimatedHours, String scheduleText, String status, String documents) {
    this.id = id; this.name = name; this.description = description; this.agencyId = agencyId; this.objective = objective; this.scope = scope; this.expectedValue = expectedValue == null ? BigDecimal.ZERO : expectedValue; this.estimatedHours = estimatedHours; this.scheduleText = scheduleText; this.status = status == null ? "PLANNED" : status; this.documents = documents; this.createdAt = Instant.now(); this.updatedAt = this.createdAt;
  }

  public UUID getId() { return id; }
  public String getName() { return name; }
  public String getStatus() { return status; }
  public BigDecimal getExpectedValue() { return expectedValue; }
  public BigDecimal getEstimatedHours() { return estimatedHours; }
}

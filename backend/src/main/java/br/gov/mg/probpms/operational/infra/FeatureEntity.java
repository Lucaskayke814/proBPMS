package br.gov.mg.probpms.operational.infra;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "feature_request")
public class FeatureEntity {
  @Id private UUID id;
  @Column(nullable = false) private String title;
  @Column(name = "system_name", nullable = false) private String systemName;
  @Column(nullable = false, columnDefinition = "text") private String description;
  @Column(name = "requester_name", nullable = false) private String requesterName;
  @Column(name = "agency_id", nullable = false) private UUID agencyId;
  @Column(name = "contract_id", nullable = false) private UUID contractId;
  @Column private String sprint;
  @Column private String version;
  @Column(nullable = false) private String status;
  @Column(name = "estimated_hours") private BigDecimal estimatedHours;
  @Column private String complexity;
  @Column(columnDefinition = "text") private String documentation;
  @Column(columnDefinition = "text") private String mockups;
  @Column(name = "created_at", nullable = false) private Instant createdAt;
  @Column(name = "updated_at", nullable = false) private Instant updatedAt;

  protected FeatureEntity() {}

  public FeatureEntity(UUID id, String title, String systemName, String description, String requesterName, UUID agencyId, UUID contractId, String sprint, String version, String status, BigDecimal estimatedHours, String complexity, String documentation, String mockups) {
    this.id = id; this.title = title; this.systemName = systemName; this.description = description; this.requesterName = requesterName; this.agencyId = agencyId; this.contractId = contractId; this.sprint = sprint; this.version = version; this.status = status == null ? "NEW" : status; this.estimatedHours = estimatedHours; this.complexity = complexity; this.documentation = documentation; this.mockups = mockups; this.createdAt = Instant.now(); this.updatedAt = this.createdAt;
  }

  public UUID getId() { return id; }
  public String getTitle() { return title; }
  public String getSystemName() { return systemName; }
  public String getStatus() { return status; }
  public String getSprint() { return sprint; }
  public String getVersion() { return version; }
}

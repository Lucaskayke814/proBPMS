package br.gov.mg.probpms.operational.infra;

import jakarta.persistence.*;
import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "publication")
public class PublicationEntity {
  @Id private UUID id;
  @Column(name = "system_name", nullable = false) private String systemName;
  @Column(nullable = false) private String version;
  @Column private String sprint;
  @Column(nullable = false, columnDefinition = "text") private String description;
  @Column(name = "homologation_date") private LocalDate homologationDate;
  @Column(name = "production_date") private LocalDate productionDate;
  @Column(name = "responsible_name") private String responsibleName;
  @Column(name = "approver_name") private String approverName;
  @Column(name = "rollback_plan", columnDefinition = "text") private String rollbackPlan;
  @Column(columnDefinition = "text") private String checklist;
  @Column(nullable = false) private String status;
  @Column(name = "created_at", nullable = false) private Instant createdAt;
  @Column(name = "updated_at", nullable = false) private Instant updatedAt;

  protected PublicationEntity() {}

  public PublicationEntity(UUID id, String systemName, String version, String sprint, String description, LocalDate homologationDate, LocalDate productionDate, String responsibleName, String approverName, String rollbackPlan, String checklist, String status) {
    this.id = id; this.systemName = systemName; this.version = version; this.sprint = sprint; this.description = description; this.homologationDate = homologationDate; this.productionDate = productionDate; this.responsibleName = responsibleName; this.approverName = approverName; this.rollbackPlan = rollbackPlan; this.checklist = checklist; this.status = status == null ? "PLANNED" : status; this.createdAt = Instant.now(); this.updatedAt = this.createdAt;
  }

  public UUID getId() { return id; }
  public String getSystemName() { return systemName; }
  public String getVersion() { return version; }
  public String getStatus() { return status; }
  public LocalDate getProductionDate() { return productionDate; }
}

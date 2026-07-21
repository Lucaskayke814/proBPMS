package br.gov.mg.probpms.demand.infra;

import br.gov.mg.probpms.demand.domain.DemandStatus;
import jakarta.persistence.*;
import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "demand")
public class DemandEntity {
  @Id private UUID id;
  @Column(nullable = false, unique = true) private String code;
  @Column(nullable = false) private String title;
  @Column(nullable = false, columnDefinition = "text") private String description;
  @Column(name = "demand_type", nullable = false) private String demandType;
  @Column(nullable = false) private String priority;
  @Enumerated(EnumType.STRING) @Column(nullable = false) private DemandStatus status;
  @Column(name = "agency_id", nullable = false) private UUID agencyId;
  @Column(name = "contract_id", nullable = false) private UUID contractId;
  @Column(name = "requester_name", nullable = false) private String requesterName;
  @Column(name = "due_date") private LocalDate dueDate;
  @Column(name = "created_at", nullable = false) private Instant createdAt;
  @Column(name = "updated_at", nullable = false) private Instant updatedAt;
  protected DemandEntity() { }
  public DemandEntity(UUID id, String code, String title, String description, String demandType, String priority, UUID agencyId, UUID contractId, String requesterName, LocalDate dueDate) {
    this.id=id; this.code=code; this.title=title; this.description=description; this.demandType=demandType; this.priority=priority; this.agencyId=agencyId; this.contractId=contractId; this.requesterName=requesterName; this.dueDate=dueDate; this.status=DemandStatus.NEW; this.createdAt=Instant.now(); this.updatedAt=this.createdAt;
  }
  public UUID getId(){return id;} public String getCode(){return code;} public String getTitle(){return title;} public DemandStatus getStatus(){return status;} public LocalDate getDueDate(){return dueDate;}
  public void changeStatus(DemandStatus status) { this.status = status; this.updatedAt = Instant.now(); }
}

package br.gov.mg.probpms.demand.infra;

import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;

@Entity @Table(name="demand_comment")
public class DemandCommentEntity {
  @Id private UUID id;
  @Column(name="demand_id",nullable=false) private UUID demandId;
  @Column(nullable=false,columnDefinition="text") private String message;
  @Column(name="author_name",nullable=false) private String authorName;
  @Column(name="created_at",nullable=false) private Instant createdAt;
  protected DemandCommentEntity() { }
  public DemandCommentEntity(UUID id,UUID demandId,String message,String authorName){this.id=id;this.demandId=demandId;this.message=message;this.authorName=authorName;this.createdAt=Instant.now();}
  public UUID getId(){return id;} public String getMessage(){return message;} public String getAuthorName(){return authorName;} public Instant getCreatedAt(){return createdAt;}
}

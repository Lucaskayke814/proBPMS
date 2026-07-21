package br.gov.mg.probpms.operational.infra;

import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "api_definition")
public class ApiEntity {
  @Id private UUID id;
  @Column(nullable = false) private String name;
  @Column(name = "consumer_system") private String consumerSystem;
  @Column(name = "provider_system") private String providerSystem;
  @Column(nullable = false) private String endpoint;
  @Column(name = "http_method", nullable = false) private String httpMethod;
  @Column private String authentication;
  @Column private String environment;
  @Column(name = "documentation_url") private String documentationUrl;
  @Column(name = "swagger_url") private String swaggerUrl;
  @Column(nullable = false) private String status;
  @Column private String version;
  @Column(name = "responsible_name") private String responsibleName;
  @Column(columnDefinition = "text") private String observations;
  @Column(name = "created_at", nullable = false) private Instant createdAt;
  @Column(name = "updated_at", nullable = false) private Instant updatedAt;

  protected ApiEntity() {}

  public ApiEntity(UUID id, String name, String consumerSystem, String providerSystem, String endpoint, String httpMethod, String authentication, String environment, String documentationUrl, String swaggerUrl, String status, String version, String responsibleName, String observations) {
    this.id = id; this.name = name; this.consumerSystem = consumerSystem; this.providerSystem = providerSystem; this.endpoint = endpoint; this.httpMethod = httpMethod == null ? "GET" : httpMethod; this.authentication = authentication; this.environment = environment; this.documentationUrl = documentationUrl; this.swaggerUrl = swaggerUrl; this.status = status == null ? "ACTIVE" : status; this.version = version; this.responsibleName = responsibleName; this.observations = observations; this.createdAt = Instant.now(); this.updatedAt = this.createdAt;
  }

  public UUID getId() { return id; }
  public String getName() { return name; }
  public String getEndpoint() { return endpoint; }
  public String getHttpMethod() { return httpMethod; }
  public String getStatus() { return status; }
}

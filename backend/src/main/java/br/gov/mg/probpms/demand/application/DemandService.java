package br.gov.mg.probpms.demand.application;

import br.gov.mg.probpms.audit.AuditService;
import br.gov.mg.probpms.demand.api.CreateDemandRequest;
import br.gov.mg.probpms.demand.api.DemandResponse;
import br.gov.mg.probpms.demand.api.ChangeDemandStatusRequest;
import br.gov.mg.probpms.demand.api.CreateCommentRequest;
import br.gov.mg.probpms.demand.api.DemandCommentResponse;
import br.gov.mg.probpms.demand.domain.DemandStatus;
import br.gov.mg.probpms.demand.infra.DemandEntity;
import br.gov.mg.probpms.demand.infra.DemandRepository;
import br.gov.mg.probpms.demand.infra.DemandCommentEntity;
import br.gov.mg.probpms.demand.infra.DemandCommentRepository;
import java.time.Year;
import java.util.UUID;
import java.util.EnumSet;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

@Service
public class DemandService {
  private final DemandRepository repository; private final DemandCommentRepository comments; private final JdbcTemplate jdbc; private final AuditService audit;
  public DemandService(DemandRepository repository, DemandCommentRepository comments, JdbcTemplate jdbc, AuditService audit) { this.repository=repository;this.comments=comments; this.jdbc=jdbc; this.audit=audit; }
  public Page<DemandResponse> list(DemandStatus status, Pageable pageable) {
    var rows = status == null ? repository.findByDeletedAtIsNull(pageable) : repository.findByStatusAndDeletedAtIsNull(status, pageable);
    return rows.map(this::toResponse);
  }
  @Transactional
  public DemandResponse create(CreateDemandRequest request) {
    long sequence = jdbc.queryForObject("SELECT nextval('demand_code_sequence')", Long.class);
    var code = "DEM-" + Year.now() + "-" + String.format("%05d", sequence);
    var entity = repository.save(new DemandEntity(UUID.randomUUID(), code, request.title(), request.description(), request.demandType(), request.priority(), request.agencyId(), request.contractId(), request.requesterName(), request.dueDate()));
    var actor = String.valueOf(SecurityContextHolder.getContext().getAuthentication().getPrincipal());
    audit.created("DEMAND", entity.getId(), actor, "{\"code\":\"" + code + "\"}");
    return toResponse(entity);
  }
  @Transactional
  public DemandResponse changeStatus(UUID id, ChangeDemandStatusRequest request) {
    var demand=findActive(id); ensureTransition(demand.getStatus(), request.status()); demand.changeStatus(request.status());
    audit.created("DEMAND", id, actor(), "{\"status\":\""+request.status()+"\",\"event\":\"STATUS_CHANGED\"}");
    return toResponse(demand);
  }
  @Transactional
  public DemandCommentResponse comment(UUID demandId, CreateCommentRequest request) {
    findActive(demandId);
    var entry=comments.save(new DemandCommentEntity(UUID.randomUUID(),demandId,request.message(),actor()));
    audit.created("DEMAND_COMMENT", entry.getId(), actor(), "{\"demandId\":\""+demandId+"\"}");
    return new DemandCommentResponse(entry.getId(),entry.getMessage(),entry.getAuthorName(),entry.getCreatedAt());
  }
  public java.util.List<DemandCommentResponse> comments(UUID demandId) {
    findActive(demandId); return comments.findByDemandIdOrderByCreatedAtDesc(demandId).stream().map(c->new DemandCommentResponse(c.getId(),c.getMessage(),c.getAuthorName(),c.getCreatedAt())).toList();
  }
  private DemandEntity findActive(UUID id) { return repository.findByIdAndDeletedAtIsNull(id).orElseThrow(()->new ResponseStatusException(HttpStatus.NOT_FOUND,"Demanda não encontrada")); }
  private String actor(){return String.valueOf(SecurityContextHolder.getContext().getAuthentication().getPrincipal());}
  private void ensureTransition(DemandStatus current, DemandStatus next) {
    if (current == next) return;
    var valid = switch (current) {
      case NEW -> EnumSet.of(DemandStatus.ANALYSIS, DemandStatus.CANCELLED, DemandStatus.REJECTED);
      case ANALYSIS -> EnumSet.of(DemandStatus.WAITING_INFORMATION, DemandStatus.PLANNED, DemandStatus.REJECTED, DemandStatus.CANCELLED);
      case WAITING_INFORMATION -> EnumSet.of(DemandStatus.ANALYSIS, DemandStatus.CANCELLED);
      case PLANNED -> EnumSet.of(DemandStatus.IN_DEVELOPMENT, DemandStatus.CANCELLED);
      case IN_DEVELOPMENT -> EnumSet.of(DemandStatus.TESTING, DemandStatus.WAITING_INFORMATION, DemandStatus.CANCELLED);
      case TESTING -> EnumSet.of(DemandStatus.HOMOLOGATION, DemandStatus.IN_DEVELOPMENT, DemandStatus.CANCELLED);
      case HOMOLOGATION -> EnumSet.of(DemandStatus.READY_TO_PUBLISH, DemandStatus.IN_DEVELOPMENT, DemandStatus.CANCELLED);
      case READY_TO_PUBLISH -> EnumSet.of(DemandStatus.PUBLISHED, DemandStatus.IN_DEVELOPMENT, DemandStatus.CANCELLED);
      case PUBLISHED -> EnumSet.of(DemandStatus.COMPLETED);
      case COMPLETED, CANCELLED, REJECTED -> EnumSet.noneOf(DemandStatus.class);
    };
    if (!valid.contains(next)) throw new ResponseStatusException(HttpStatus.UNPROCESSABLE_ENTITY, "Transição de status não permitida");
  }
  private DemandResponse toResponse(DemandEntity demand) { return new DemandResponse(demand.getId(), demand.getCode(), demand.getTitle(), "", demand.getStatus(), demand.getDueDate()); }
}

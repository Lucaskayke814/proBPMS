package br.gov.mg.probpms.financial.application;

import br.gov.mg.probpms.audit.AuditService;
import br.gov.mg.probpms.financial.api.*;
import br.gov.mg.probpms.financial.domain.FinancialMovementType;
import java.math.BigDecimal;
import java.util.Map;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

@Service
public class FinancialCommandService {
  private final JdbcTemplate jdbc; private final AuditService audit;
  public FinancialCommandService(JdbcTemplate jdbc, AuditService audit) { this.jdbc=jdbc;this.audit=audit; }
  @Transactional
  public UUID createAppropriation(CreateAppropriationRequest request) {
    var id=UUID.randomUUID();
    jdbc.update("INSERT INTO budget_appropriation (id,number,year,agency_id,contract_id,initial_amount) VALUES (?,?,?,?,?,?)", id,request.number(),request.year(),request.agencyId(),request.contractId(),request.initialAmount());
    audit.created("BUDGET_APPROPRIATION", id, actor(), "{\"number\":\""+request.number().replace("\"", "")+"\"}");
    return id;
  }
  @Transactional
  public UUID recordMovement(CreateFinancialMovementRequest request) {
    Map<String,Object> balance;
    try { balance=jdbc.queryForMap("SELECT initial_amount, committed_amount, settled_amount, paid_amount FROM budget_appropriation WHERE id=? FOR UPDATE",request.appropriationId()); }
    catch (org.springframework.dao.EmptyResultDataAccessException e) { throw new ResponseStatusException(HttpStatus.NOT_FOUND,"Dotação não encontrada"); }
    var initial=(BigDecimal)balance.get("initial_amount"); var committed=(BigDecimal)balance.get("committed_amount"); var settled=(BigDecimal)balance.get("settled_amount"); var paid=(BigDecimal)balance.get("paid_amount");
    switch(request.movementType()) {
      case REINFORCEMENT -> initial=initial.add(request.amount());
      case COMMITMENT -> { requireAtMost(request.amount(),initial.subtract(committed),"empenho"); committed=committed.add(request.amount()); }
      case SETTLEMENT -> { requireAtMost(request.amount(),committed.subtract(settled),"liquidação"); settled=settled.add(request.amount()); }
      case PAYMENT -> { requireAtMost(request.amount(),settled.subtract(paid),"pagamento"); paid=paid.add(request.amount()); }
      case REVERSAL -> { requireAtMost(request.amount(),committed.subtract(settled),"estorno"); committed=committed.subtract(request.amount()); }
      case ALLOCATION -> throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"A dotação inicial é criada no cadastro da dotação");
    }
    jdbc.update("UPDATE budget_appropriation SET initial_amount=?, committed_amount=?, settled_amount=?, paid_amount=?, updated_at=now() WHERE id=?",initial,committed,settled,paid,request.appropriationId());
    var id=UUID.randomUUID();
    jdbc.update("INSERT INTO financial_movement (id,appropriation_id,movement_type,amount,occurred_on,reference_number,description,created_by) VALUES (?,?,CAST(? AS financial_movement_type),?,?,?,?,?)",id,request.appropriationId(),request.movementType().name(),request.amount(),request.occurredOn(),request.referenceNumber(),request.description(),actor());
    audit.created("FINANCIAL_MOVEMENT",id,actor(),"{\"type\":\""+request.movementType()+"\"}");
    return id;
  }
  private void requireAtMost(BigDecimal value,BigDecimal limit,String operation){if(value.compareTo(limit)>0) throw new ResponseStatusException(HttpStatus.UNPROCESSABLE_ENTITY,"Valor excede o saldo disponível para "+operation);}
  private String actor(){return String.valueOf(SecurityContextHolder.getContext().getAuthentication().getPrincipal());}
}

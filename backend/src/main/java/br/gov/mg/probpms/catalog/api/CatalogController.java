package br.gov.mg.probpms.catalog.api;

import br.gov.mg.probpms.catalog.infra.*;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;
import org.springframework.http.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1")
public class CatalogController {
  private final ContractRepository contracts;
  private final AgencyRepository agencies;

  public CatalogController(ContractRepository contracts, AgencyRepository agencies) {
    this.contracts = contracts;
    this.agencies = agencies;
  }

  @GetMapping("/contracts")
  @PreAuthorize("isAuthenticated()")
  public java.util.List<ContractView> contracts() {
    return contracts.findAll().stream().map(c -> new ContractView(c.getId(), c.getNumber(), c.getYear(),
        c.getObjectDescription(), c.getTotalAmount(), c.getStatus())).toList();
  }

  @GetMapping("/contracts/{id}")
  @PreAuthorize("isAuthenticated()")
  public ResponseEntity<ContractDetailResponse> contract(@PathVariable UUID id) {
    var contract = contracts.findById(id)
        .orElseThrow(() -> new org.springframework.web.server.ResponseStatusException(HttpStatus.NOT_FOUND,
            "Contrato não encontrado"));
    return ResponseEntity.ok(new ContractDetailResponse(
        contract.getId(),
        contract.getNumber(),
        contract.getYear(),
        contract.getObjectDescription(),
        contract.getSupplierName(),
        contract.getTotalAmount(),
        contract.getExecutedAmount(),
        contract.getBalanceAmount(),
        contract.getStartsOn(),
        contract.getEndsOn(),
        contract.getStatus(),
        contract.getManagerName(),
        contract.getFiscalName(),
        contract.getRemainingDays(),
        contract.getCommittedAmount(),
        contract.getSettledAmount(),
        contract.getPaidAmount(),
        contract.getNotes()));
  }

  @PostMapping("/contracts")
  @PreAuthorize("hasRole('GESTOR_CENTRAL')")
  public ResponseEntity<ContractView> createContract(@RequestBody @Valid CreateContractRequest request) {
    var entity = contracts.save(new ContractEntity(
        UUID.randomUUID(),
        request.number(),
        request.year(),
        request.objectDescription(),
        request.supplierName(),
        request.totalAmount(),
        request.startsOn(),
        request.endsOn(),
        request.managerName(),
        request.fiscalName(),
        request.notes()));
    return ResponseEntity.status(HttpStatus.CREATED).body(new ContractView(entity.getId(), entity.getNumber(),
        entity.getYear(), entity.getObjectDescription(), entity.getTotalAmount(), entity.getStatus()));
  }

  @PatchMapping("/contracts/{id}")
  @PreAuthorize("hasRole('GESTOR_CENTRAL')")
  public ResponseEntity<ContractDetailResponse> updateContract(@PathVariable UUID id,
      @RequestBody @Valid UpdateContractRequest request) {
    var entity = contracts.findById(id)
        .orElseThrow(() -> new org.springframework.web.server.ResponseStatusException(HttpStatus.NOT_FOUND,
            "Contrato não encontrado"));
    entity.applyPatch(request);
    var saved = contracts.save(entity);
    return ResponseEntity.ok(new ContractDetailResponse(
        saved.getId(),
        saved.getNumber(),
        saved.getYear(),
        saved.getObjectDescription(),
        saved.getSupplierName(),
        saved.getTotalAmount(),
        saved.getExecutedAmount(),
        saved.getBalanceAmount(),
        saved.getStartsOn(),
        saved.getEndsOn(),
        saved.getStatus(),
        saved.getManagerName(),
        saved.getFiscalName(),
        saved.getRemainingDays(),
        saved.getCommittedAmount(),
        saved.getSettledAmount(),
        saved.getPaidAmount(),
        saved.getNotes()));
  }

  @GetMapping("/agencies")
  @PreAuthorize("isAuthenticated()")
  public java.util.List<AgencyView> agencies() {
    return agencies.findAll().stream().map(a -> new AgencyView(a.getId(), a.getName(), a.getAcronym())).toList();
  }

  @GetMapping("/agencies/{id}")
  @PreAuthorize("isAuthenticated()")
  public ResponseEntity<AgencyDetailResponse> agency(@PathVariable UUID id) {
    var agency = agencies.findById(id).orElseThrow(
        () -> new org.springframework.web.server.ResponseStatusException(HttpStatus.NOT_FOUND, "Órgão não encontrado"));
    return ResponseEntity.ok(new AgencyDetailResponse(
        agency.getId(),
        agency.getName(),
        agency.getAcronym(),
        agency.getContactName(),
        agency.getContactEmail(),
        agency.getPhone(),
        agency.getAvailableAmount(),
        agency.getConsumedAmount(),
        agency.getBalanceAmount(),
        agency.getNotes()));
  }

  @PostMapping("/agencies")
  @PreAuthorize("hasRole('GESTOR_CENTRAL')")
  public ResponseEntity<AgencyView> createAgency(@RequestBody @Valid CreateAgencyRequest request) {
    var entity = agencies.save(new AgencyEntity(
        UUID.randomUUID(),
        request.name(),
        request.acronym(),
        request.contactName(),
        request.contactEmail(),
        request.phone(),
        request.availableAmount(),
        request.notes()));
    return ResponseEntity.status(HttpStatus.CREATED)
        .body(new AgencyView(entity.getId(), entity.getName(), entity.getAcronym()));
  }

  @PatchMapping("/agencies/{id}")
  @PreAuthorize("hasRole('GESTOR_CENTRAL')")
  public ResponseEntity<AgencyDetailResponse> updateAgency(@PathVariable UUID id,
      @RequestBody @Valid UpdateAgencyRequest request) {
    var entity = agencies.findById(id).orElseThrow(
        () -> new org.springframework.web.server.ResponseStatusException(HttpStatus.NOT_FOUND, "Órgão não encontrado"));
    entity.applyPatch(request);
    var saved = agencies.save(entity);
    return ResponseEntity.ok(new AgencyDetailResponse(
        saved.getId(),
        saved.getName(),
        saved.getAcronym(),
        saved.getContactName(),
        saved.getContactEmail(),
        saved.getPhone(),
        saved.getAvailableAmount(),
        saved.getConsumedAmount(),
        saved.getBalanceAmount(),
        saved.getNotes()));
  }

  public record CreateContractRequest(@NotBlank String number, @Min(2020) short year,
      @NotBlank String objectDescription, @NotBlank String supplierName,
      @NotNull @DecimalMin("0.01") BigDecimal totalAmount, @NotNull LocalDate startsOn, @NotNull LocalDate endsOn,
      String managerName, String fiscalName, String notes) {
  }

  public record ContractView(UUID id, String number, short year, String objectDescription, BigDecimal totalAmount,
      String status) {
  }

  public record CreateAgencyRequest(@NotBlank String name, @NotBlank @Size(max = 30) String acronym, String contactName,
      @Email String contactEmail, String phone, BigDecimal availableAmount, String notes) {
  }

  public record AgencyView(UUID id, String name, String acronym) {
  }
}

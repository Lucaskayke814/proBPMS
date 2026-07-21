package br.gov.mg.probpms.financial.api;

import br.gov.mg.probpms.financial.application.FinancialSummaryService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.security.access.prepost.PreAuthorize;

@RestController
@RequestMapping("/api/v1/financial")
public class FinancialSummaryController {
  private final FinancialSummaryService service;
  public FinancialSummaryController(FinancialSummaryService service) { this.service = service; }
  @GetMapping("/summary")
  @PreAuthorize("hasRole('GESTOR_CENTRAL')")
  public ResponseEntity<FinancialSummaryResponse> summary() {
    return ResponseEntity.ok(service.summary());
  }
}

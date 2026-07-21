package br.gov.mg.probpms.financial.api;

import br.gov.mg.probpms.financial.application.FinancialCommandService;
import jakarta.validation.Valid;
import java.util.Map;
import org.springframework.http.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/financial")
@PreAuthorize("hasRole('GESTOR_CENTRAL')")
public class FinancialCommandController {
  private final FinancialCommandService service;
  public FinancialCommandController(FinancialCommandService service){this.service=service;}
  @PostMapping("/appropriations")
  public ResponseEntity<Map<String,String>> createAppropriation(@RequestBody @Valid CreateAppropriationRequest request){
    var id=service.createAppropriation(request); return ResponseEntity.status(HttpStatus.CREATED).body(Map.of("id",id.toString()));
  }
  @PostMapping("/movements")
  public ResponseEntity<Map<String,String>> createMovement(@RequestBody @Valid CreateFinancialMovementRequest request){
    var id=service.recordMovement(request); return ResponseEntity.status(HttpStatus.CREATED).body(Map.of("id",id.toString()));
  }
}

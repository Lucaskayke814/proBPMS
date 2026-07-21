package br.gov.mg.probpms.demand.api;

import br.gov.mg.probpms.demand.domain.DemandStatus;
import br.gov.mg.probpms.demand.application.DemandService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.security.access.prepost.PreAuthorize;

@RestController
@RequestMapping("/api/v1/demands")
public class DemandController {
  private final DemandService service;
  public DemandController(DemandService service) { this.service = service; }

  @GetMapping
  @PreAuthorize("hasAnyRole('GESTOR_CENTRAL', 'GESTOR_SETORIAL', 'TECNICO')")
  public ResponseEntity<Page<DemandResponse>> list(@RequestParam(required = false) DemandStatus status,
      @PageableDefault(size = 20, sort = "createdAt", direction = org.springframework.data.domain.Sort.Direction.DESC) Pageable pageable) {
    return ResponseEntity.ok(service.list(status, pageable));
  }
  @PostMapping
  @PreAuthorize("hasAnyRole('GESTOR_CENTRAL', 'GESTOR_SETORIAL')")
  public ResponseEntity<DemandResponse> create(@RequestBody @jakarta.validation.Valid CreateDemandRequest request) {
    return ResponseEntity.status(HttpStatus.CREATED).body(service.create(request));
  }
  @PatchMapping("/{id}/status")
  @PreAuthorize("hasAnyRole('GESTOR_CENTRAL', 'TECNICO')")
  public ResponseEntity<DemandResponse> changeStatus(@PathVariable java.util.UUID id,@RequestBody @jakarta.validation.Valid ChangeDemandStatusRequest request){return ResponseEntity.ok(service.changeStatus(id,request));}
  @GetMapping("/{id}/comments")
  @PreAuthorize("isAuthenticated()")
  public ResponseEntity<java.util.List<DemandCommentResponse>> comments(@PathVariable java.util.UUID id){return ResponseEntity.ok(service.comments(id));}
  @PostMapping("/{id}/comments")
  @PreAuthorize("isAuthenticated()")
  public ResponseEntity<DemandCommentResponse> comment(@PathVariable java.util.UUID id,@RequestBody @jakarta.validation.Valid CreateCommentRequest request){return ResponseEntity.status(HttpStatus.CREATED).body(service.comment(id,request));}
}

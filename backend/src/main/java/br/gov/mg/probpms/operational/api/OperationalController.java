package br.gov.mg.probpms.operational.api;

import br.gov.mg.probpms.operational.application.OperationalService;
import jakarta.validation.Valid;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/operational")
public class OperationalController {
    private final OperationalService service;

    public OperationalController(OperationalService service) {
        this.service = service;
    }

    @GetMapping("/dashboard")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Map<String, Object>> dashboard() {
        return ResponseEntity.ok(service.dashboard());
    }

    @GetMapping("/features")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<List<FeatureResponse>> features() {
        return ResponseEntity.ok(service.listFeatures());
    }

    @PostMapping("/features")
    @PreAuthorize("hasAnyRole('GESTOR_CENTRAL', 'GESTOR_SETORIAL')")
    public ResponseEntity<FeatureResponse> createFeature(@RequestBody @Valid CreateFeatureRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.createFeature(request));
    }

    @GetMapping("/errors")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<List<ErrorResponse>> errors() {
        return ResponseEntity.ok(service.listErrors());
    }

    @PostMapping("/errors")
    @PreAuthorize("hasAnyRole('GESTOR_CENTRAL', 'TECNICO')")
    public ResponseEntity<ErrorResponse> createError(@RequestBody @Valid CreateErrorRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.createError(request));
    }

    @GetMapping("/apis")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<List<ApiResponse>> apis() {
        return ResponseEntity.ok(service.listApis());
    }

    @PostMapping("/apis")
    @PreAuthorize("hasAnyRole('GESTOR_CENTRAL', 'GESTOR_SETORIAL')")
    public ResponseEntity<ApiResponse> createApi(@RequestBody @Valid CreateApiRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.createApi(request));
    }

    @GetMapping("/publications")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<List<PublicationResponse>> publications() {
        return ResponseEntity.ok(service.listPublications());
    }

    @PostMapping("/publications")
    @PreAuthorize("hasAnyRole('GESTOR_CENTRAL', 'TECNICO')")
    public ResponseEntity<PublicationResponse> createPublication(@RequestBody @Valid CreatePublicationRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.createPublication(request));
    }

    @GetMapping("/modules")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<List<ModuleResponse>> modules() {
        return ResponseEntity.ok(service.listModules());
    }

    @PostMapping("/modules")
    @PreAuthorize("hasRole('GESTOR_CENTRAL')")
    public ResponseEntity<ModuleResponse> createModule(@RequestBody @Valid CreateModuleRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.createModule(request));
    }
}

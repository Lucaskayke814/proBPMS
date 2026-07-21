package br.gov.mg.probpms.operational.application;

import br.gov.mg.probpms.operational.api.*;
import br.gov.mg.probpms.operational.infra.*;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.springframework.stereotype.Service;

@Service
public class OperationalService {
    private final FeatureRepository features;
    private final ErrorRepository errors;
    private final ApiRepository apis;
    private final PublicationRepository publications;
    private final ModuleRepository modules;

    public OperationalService(FeatureRepository features, ErrorRepository errors, ApiRepository apis,
            PublicationRepository publications, ModuleRepository modules) {
        this.features = features;
        this.errors = errors;
        this.apis = apis;
        this.publications = publications;
        this.modules = modules;
    }

    public Map<String, Object> dashboard() {
        return Map.of(
                "totalFeatures", features.count(),
                "totalErrors", errors.count(),
                "totalApis", apis.count(),
                "totalPublications", publications.count(),
                "totalModules", modules.count());
    }

    public List<FeatureResponse> listFeatures() {
        return features.findAll().stream().map(this::toFeatureResponse).toList();
    }

    public FeatureResponse createFeature(CreateFeatureRequest request) {
        var entity = features.save(new FeatureEntity(UUID.randomUUID(), request.title(), request.systemName(),
                request.description(), request.requesterName(), request.agencyId(), request.contractId(),
                request.sprint(), request.version(), request.status(), request.estimatedHours(), request.complexity(),
                request.documentation(), request.mockups()));
        return toFeatureResponse(entity);
    }

    public List<ErrorResponse> listErrors() {
        return errors.findAll().stream().map(this::toErrorResponse).toList();
    }

    public ErrorResponse createError(CreateErrorRequest request) {
        var entity = errors.save(new ErrorEntity(UUID.randomUUID(), request.systemName(), request.description(),
                request.severity(), request.environment(), request.stepsToReproduce(), request.printPath(),
                request.videoUrl(), request.responsibleName(), request.version(), request.correctionNotes(),
                request.status(), request.resolutionTimeHours()));
        return toErrorResponse(entity);
    }

    public List<ApiResponse> listApis() {
        return apis.findAll().stream().map(this::toApiResponse).toList();
    }

    public ApiResponse createApi(CreateApiRequest request) {
        var entity = apis.save(new ApiEntity(UUID.randomUUID(), request.name(), request.consumerSystem(),
                request.providerSystem(), request.endpoint(), request.httpMethod(), request.authentication(),
                request.environment(), request.documentationUrl(), request.swaggerUrl(), request.status(),
                request.version(), request.responsibleName(), request.observations()));
        return toApiResponse(entity);
    }

    public List<PublicationResponse> listPublications() {
        return publications.findAll().stream().map(this::toPublicationResponse).toList();
    }

    public PublicationResponse createPublication(CreatePublicationRequest request) {
        var entity = publications.save(new PublicationEntity(UUID.randomUUID(), request.systemName(), request.version(),
                request.sprint(), request.description(), request.homologationDate(), request.productionDate(),
                request.responsibleName(), request.approverName(), request.rollbackPlan(), request.checklist(),
                request.status()));
        return toPublicationResponse(entity);
    }

    public List<ModuleResponse> listModules() {
        return modules.findAll().stream().map(this::toModuleResponse).toList();
    }

    public ModuleResponse createModule(CreateModuleRequest request) {
        var entity = modules.save(new ModuleEntity(UUID.randomUUID(), request.name(), request.description(),
                request.agencyId(), request.objective(), request.scope(), request.expectedValue(),
                request.estimatedHours(), request.scheduleText(), request.status(), request.documents()));
        return toModuleResponse(entity);
    }

    private FeatureResponse toFeatureResponse(FeatureEntity entity) {
        return new FeatureResponse(entity.getId(), entity.getTitle(), entity.getSystemName(), entity.getStatus(),
                entity.getSprint(), entity.getVersion());
    }

    private ErrorResponse toErrorResponse(ErrorEntity entity) {
        return new ErrorResponse(entity.getId(), entity.getSystemName(), entity.getSeverity(), entity.getStatus(),
                entity.getResponsibleName());
    }

    private ApiResponse toApiResponse(ApiEntity entity) {
        return new ApiResponse(entity.getId(), entity.getName(), entity.getEndpoint(), entity.getHttpMethod(),
                entity.getStatus());
    }

    private PublicationResponse toPublicationResponse(PublicationEntity entity) {
        return new PublicationResponse(entity.getId(), entity.getSystemName(), entity.getVersion(), entity.getStatus(),
                entity.getProductionDate());
    }

    private ModuleResponse toModuleResponse(ModuleEntity entity) {
        return new ModuleResponse(entity.getId(), entity.getName(), entity.getStatus(), entity.getExpectedValue(),
                entity.getEstimatedHours());
    }
}

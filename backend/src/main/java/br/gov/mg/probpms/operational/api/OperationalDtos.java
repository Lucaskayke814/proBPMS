package br.gov.mg.probpms.operational.api;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record CreateFeatureRequest(
        String title,
        String systemName,
        String description,
        String requesterName,
        UUID agencyId,
        UUID contractId,
        String sprint,
        String version,
        String status,
        BigDecimal estimatedHours,
        String complexity,
        String documentation,
        String mockups) {
}

public record FeatureResponse(UUID id, String title, String systemName, String status, String sprint, String version) {
}

public record CreateErrorRequest(
        String systemName,
        String description,
        String severity,
        String environment,
        String stepsToReproduce,
        String printPath,
        String videoUrl,
        String responsibleName,
        String version,
        String correctionNotes,
        String status,
        BigDecimal resolutionTimeHours) {
}

public record ErrorResponse(UUID id, String systemName, String severity, String status, String responsibleName) {
}

public record CreateApiRequest(
        String name,
        String consumerSystem,
        String providerSystem,
        String endpoint,
        String httpMethod,
        String authentication,
        String environment,
        String documentationUrl,
        String swaggerUrl,
        String status,
        String version,
        String responsibleName,
        String observations) {
}

public record ApiResponse(UUID id, String name, String endpoint, String httpMethod, String status) {
}

public record CreatePublicationRequest(
        String systemName,
        String version,
        String sprint,
        String description,
        LocalDate homologationDate,
        LocalDate productionDate,
        String responsibleName,
        String approverName,
        String rollbackPlan,
        String checklist,
        String status) {
}

public record PublicationResponse(UUID id, String systemName, String version, String status, LocalDate productionDate) {
}

public record CreateModuleRequest(
        String name,
        String description,
        UUID agencyId,
        String objective,
        String scope,
        BigDecimal expectedValue,
        BigDecimal estimatedHours,
        String scheduleText,
        String status,
        String documents) {
}

public record ModuleResponse(UUID id, String name, String status, BigDecimal expectedValue, BigDecimal estimatedHours) {
}

package br.gov.mg.probpms.demand.api;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;
import java.util.UUID;

public record CreateDemandRequest(
    @NotBlank String title,
    @NotBlank String description,
    @NotBlank String demandType,
    @NotBlank String priority,
    @NotNull UUID agencyId,
    @NotNull UUID contractId,
    @NotBlank String requesterName,
    LocalDate dueDate) { }

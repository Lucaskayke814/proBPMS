package br.gov.mg.probpms.financial.api;

import jakarta.validation.constraints.*;
import java.math.BigDecimal;
import java.util.UUID;

public record CreateAppropriationRequest(
    @NotBlank String number, @Min(2020) short year,
    @NotNull UUID agencyId, @NotNull UUID contractId,
    @NotNull @DecimalMin("0.01") BigDecimal initialAmount) { }

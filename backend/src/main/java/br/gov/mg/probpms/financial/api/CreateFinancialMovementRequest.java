package br.gov.mg.probpms.financial.api;

import br.gov.mg.probpms.financial.domain.FinancialMovementType;
import jakarta.validation.constraints.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record CreateFinancialMovementRequest(
    @NotNull UUID appropriationId, @NotNull FinancialMovementType movementType,
    @NotNull @DecimalMin("0.01") BigDecimal amount, @NotNull LocalDate occurredOn,
    @Size(max = 100) String referenceNumber, @NotBlank String description) { }

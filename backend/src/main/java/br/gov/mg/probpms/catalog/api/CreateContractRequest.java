package br.gov.mg.probpms.catalog.api;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;

public record CreateContractRequest(
        @NotBlank String number,
        @Min(2020) short year,
        @NotBlank String objectDescription,
        @NotBlank String supplierName,
        @NotNull @DecimalMin("0.01") BigDecimal totalAmount,
        @NotNull LocalDate startsOn,
        @NotNull LocalDate endsOn,
        String managerName,
        String fiscalName,
        String notes) {
}

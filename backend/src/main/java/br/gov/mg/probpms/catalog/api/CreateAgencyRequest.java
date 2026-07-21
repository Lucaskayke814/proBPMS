package br.gov.mg.probpms.catalog.api;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record CreateAgencyRequest(
        @NotBlank String name,
        @NotBlank @Size(max = 30) String acronym,
        String contactName,
        @Email String contactEmail,
        String phone,
        java.math.BigDecimal availableAmount,
        String notes) {
}

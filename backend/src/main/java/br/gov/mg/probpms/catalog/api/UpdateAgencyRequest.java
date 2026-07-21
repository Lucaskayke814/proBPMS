package br.gov.mg.probpms.catalog.api;

import java.math.BigDecimal;

public record UpdateAgencyRequest(
        String name,
        String acronym,
        String contactName,
        String contactEmail,
        String phone,
        BigDecimal availableAmount,
        BigDecimal consumedAmount,
        BigDecimal balanceAmount,
        String notes) {
}

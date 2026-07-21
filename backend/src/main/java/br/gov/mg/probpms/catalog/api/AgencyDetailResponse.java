package br.gov.mg.probpms.catalog.api;

import java.math.BigDecimal;
import java.util.UUID;

public record AgencyDetailResponse(
        UUID id,
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

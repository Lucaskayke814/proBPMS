package br.gov.mg.probpms.catalog.api;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

public record ContractDetailResponse(
        UUID id,
        String number,
        short year,
        String objectDescription,
        String supplierName,
        BigDecimal totalAmount,
        BigDecimal executedAmount,
        BigDecimal balanceAmount,
        LocalDate startsOn,
        LocalDate endsOn,
        String status,
        String managerName,
        String fiscalName,
        Integer remainingDays,
        BigDecimal committedAmount,
        BigDecimal settledAmount,
        BigDecimal paidAmount,
        String notes) {
}

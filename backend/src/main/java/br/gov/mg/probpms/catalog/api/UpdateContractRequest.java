package br.gov.mg.probpms.catalog.api;

import java.math.BigDecimal;
import java.time.LocalDate;

public record UpdateContractRequest(
        String number,
        Short year,
        String objectDescription,
        String supplierName,
        BigDecimal totalAmount,
        BigDecimal executedAmount,
        BigDecimal committedAmount,
        BigDecimal settledAmount,
        BigDecimal paidAmount,
        LocalDate startsOn,
        LocalDate endsOn,
        String status,
        String managerName,
        String fiscalName,
        Integer remainingDays,
        String notes) {
}

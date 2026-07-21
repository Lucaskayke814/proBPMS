package br.gov.mg.probpms.financial.api;

import java.math.BigDecimal;

public record FinancialSummaryResponse(
    BigDecimal contractTotal,
    BigDecimal committed,
    BigDecimal settled,
    BigDecimal paid,
    BigDecimal available) { }

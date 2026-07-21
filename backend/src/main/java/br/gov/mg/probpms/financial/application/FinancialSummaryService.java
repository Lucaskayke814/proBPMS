package br.gov.mg.probpms.financial.application;

import br.gov.mg.probpms.financial.api.FinancialSummaryResponse;
import java.math.BigDecimal;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class FinancialSummaryService {
  private final JdbcTemplate jdbc;
  public FinancialSummaryService(JdbcTemplate jdbc) { this.jdbc = jdbc; }

  public FinancialSummaryResponse summary() {
    var sql = """
      SELECT COALESCE((SELECT SUM(total_amount) FROM contract), 0) AS total,
             COALESCE((SELECT SUM(amount) FROM financial_movement WHERE movement_type = 'COMMITMENT'), 0) AS committed,
             COALESCE((SELECT SUM(amount) FROM financial_movement WHERE movement_type = 'SETTLEMENT'), 0) AS settled,
             COALESCE((SELECT SUM(amount) FROM financial_movement WHERE movement_type = 'PAYMENT'), 0) AS paid
      """;
    return jdbc.queryForObject(sql, (rs, row) -> {
      var total = rs.getBigDecimal("total");
      var committed = rs.getBigDecimal("committed");
      return new FinancialSummaryResponse(total, committed, rs.getBigDecimal("settled"), rs.getBigDecimal("paid"), total.subtract(committed));
    });
  }
}

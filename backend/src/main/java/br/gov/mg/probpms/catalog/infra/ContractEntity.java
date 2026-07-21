package br.gov.mg.probpms.catalog.infra;

import br.gov.mg.probpms.catalog.api.UpdateContractRequest;
import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "contract")
public class ContractEntity {
  @Id
  private UUID id;
  @Column(nullable = false)
  private String number;
  @Column(nullable = false)
  private short year;
  @Column(name = "object_description", nullable = false)
  private String objectDescription;
  @Column(name = "supplier_name", nullable = false)
  private String supplierName;
  @Column(name = "total_amount", nullable = false)
  private BigDecimal totalAmount;
  @Column(name = "executed_amount", nullable = false)
  private BigDecimal executedAmount = BigDecimal.ZERO;
  @Column(name = "balance_amount", nullable = false)
  private BigDecimal balanceAmount = BigDecimal.ZERO;
  @Column(name = "starts_on", nullable = false)
  private LocalDate startsOn;
  @Column(name = "ends_on", nullable = false)
  private LocalDate endsOn;
  @Column(nullable = false)
  private String status;
  @Column(name = "manager_name")
  private String managerName;
  @Column(name = "fiscal_name")
  private String fiscalName;
  @Column(name = "remaining_days")
  private Integer remainingDays;
  @Column(name = "committed_amount", nullable = false)
  private BigDecimal committedAmount = BigDecimal.ZERO;
  @Column(name = "settled_amount", nullable = false)
  private BigDecimal settledAmount = BigDecimal.ZERO;
  @Column(name = "paid_amount", nullable = false)
  private BigDecimal paidAmount = BigDecimal.ZERO;
  @Column(name = "notes", columnDefinition = "text")
  private String notes;

  protected ContractEntity() {
  }

  public ContractEntity(UUID id, String number, short year, String objectDescription, String supplierName,
      BigDecimal totalAmount, LocalDate startsOn, LocalDate endsOn, String managerName, String fiscalName,
      String notes) {
    this.id = id;
    this.number = number;
    this.year = year;
    this.objectDescription = objectDescription;
    this.supplierName = supplierName;
    this.totalAmount = totalAmount;
    this.startsOn = startsOn;
    this.endsOn = endsOn;
    this.status = "ACTIVE";
    this.managerName = managerName;
    this.fiscalName = fiscalName;
    this.notes = notes;
    this.executedAmount = BigDecimal.ZERO;
    this.balanceAmount = totalAmount;
    this.committedAmount = BigDecimal.ZERO;
    this.settledAmount = BigDecimal.ZERO;
    this.paidAmount = BigDecimal.ZERO;
  }

  public UUID getId() {
    return id;
  }

  public String getNumber() {
    return number;
  }

  public short getYear() {
    return year;
  }

  public String getObjectDescription() {
    return objectDescription;
  }

  public String getSupplierName() {
    return supplierName;
  }

  public BigDecimal getTotalAmount() {
    return totalAmount;
  }

  public String getStatus() {
    return status;
  }

  public BigDecimal getExecutedAmount() {
    return executedAmount;
  }

  public BigDecimal getBalanceAmount() {
    return balanceAmount;
  }

  public LocalDate getStartsOn() {
    return startsOn;
  }

  public LocalDate getEndsOn() {
    return endsOn;
  }

  public String getManagerName() {
    return managerName;
  }

  public String getFiscalName() {
    return fiscalName;
  }

  public Integer getRemainingDays() {
    return remainingDays;
  }

  public BigDecimal getCommittedAmount() {
    return committedAmount;
  }

  public BigDecimal getSettledAmount() {
    return settledAmount;
  }

  public BigDecimal getPaidAmount() {
    return paidAmount;
  }

  public String getNotes() {
    return notes;
  }

  public void applyPatch(UpdateContractRequest request) {
    if (request.number() != null)
      this.number = request.number();
    if (request.year() != null)
      this.year = request.year();
    if (request.objectDescription() != null)
      this.objectDescription = request.objectDescription();
    if (request.supplierName() != null)
      this.supplierName = request.supplierName();
    if (request.totalAmount() != null)
      this.totalAmount = request.totalAmount();
    if (request.executedAmount() != null)
      this.executedAmount = request.executedAmount();
    if (request.committedAmount() != null)
      this.committedAmount = request.committedAmount();
    if (request.settledAmount() != null)
      this.settledAmount = request.settledAmount();
    if (request.paidAmount() != null)
      this.paidAmount = request.paidAmount();
    if (request.startsOn() != null)
      this.startsOn = request.startsOn();
    if (request.endsOn() != null)
      this.endsOn = request.endsOn();
    if (request.status() != null)
      this.status = request.status();
    if (request.managerName() != null)
      this.managerName = request.managerName();
    if (request.fiscalName() != null)
      this.fiscalName = request.fiscalName();
    if (request.remainingDays() != null)
      this.remainingDays = request.remainingDays();
    if (request.notes() != null)
      this.notes = request.notes();
    this.balanceAmount = this.totalAmount.subtract(this.executedAmount);
  }
}

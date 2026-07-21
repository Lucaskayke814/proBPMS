package br.gov.mg.probpms.catalog.infra;

import br.gov.mg.probpms.catalog.api.UpdateAgencyRequest;
import jakarta.persistence.*;
import java.math.BigDecimal;
import java.util.UUID;

@Entity
@Table(name = "agency")
public class AgencyEntity {
  @Id
  private UUID id;
  @Column(nullable = false)
  private String name;
  @Column(nullable = false, unique = true)
  private String acronym;
  @Column(name = "contact_name")
  private String contactName;
  @Column(name = "contact_email")
  private String contactEmail;
  @Column(name = "phone")
  private String phone;
  @Column(name = "available_amount", nullable = false)
  private BigDecimal availableAmount = BigDecimal.ZERO;
  @Column(name = "consumed_amount", nullable = false)
  private BigDecimal consumedAmount = BigDecimal.ZERO;
  @Column(name = "balance_amount", nullable = false)
  private BigDecimal balanceAmount = BigDecimal.ZERO;
  @Column(name = "notes", columnDefinition = "text")
  private String notes;

  protected AgencyEntity() {
  }

  public AgencyEntity(UUID id, String name, String acronym, String contactName, String contactEmail, String phone,
      BigDecimal availableAmount, String notes) {
    this.id = id;
    this.name = name;
    this.acronym = acronym;
    this.contactName = contactName;
    this.contactEmail = contactEmail;
    this.phone = phone;
    this.availableAmount = availableAmount == null ? BigDecimal.ZERO : availableAmount;
    this.consumedAmount = BigDecimal.ZERO;
    this.balanceAmount = this.availableAmount;
    this.notes = notes;
  }

  public UUID getId() {
    return id;
  }

  public String getName() {
    return name;
  }

  public String getAcronym() {
    return acronym;
  }

  public String getContactName() {
    return contactName;
  }

  public String getContactEmail() {
    return contactEmail;
  }

  public String getPhone() {
    return phone;
  }

  public BigDecimal getAvailableAmount() {
    return availableAmount;
  }

  public BigDecimal getConsumedAmount() {
    return consumedAmount;
  }

  public BigDecimal getBalanceAmount() {
    return balanceAmount;
  }

  public String getNotes() {
    return notes;
  }

  public void applyPatch(UpdateAgencyRequest request) {
    if (request.name() != null)
      this.name = request.name();
    if (request.acronym() != null)
      this.acronym = request.acronym();
    if (request.contactName() != null)
      this.contactName = request.contactName();
    if (request.contactEmail() != null)
      this.contactEmail = request.contactEmail();
    if (request.phone() != null)
      this.phone = request.phone();
    if (request.availableAmount() != null)
      this.availableAmount = request.availableAmount();
    if (request.consumedAmount() != null)
      this.consumedAmount = request.consumedAmount();
    if (request.balanceAmount() != null)
      this.balanceAmount = request.balanceAmount();
    if (request.notes() != null)
      this.notes = request.notes();
  }
}

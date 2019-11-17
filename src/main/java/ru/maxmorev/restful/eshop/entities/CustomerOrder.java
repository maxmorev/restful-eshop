package ru.maxmorev.restful.eshop.entities;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import ru.maxmorev.restful.eshop.annotation.CustomerOrderStatus;
import ru.maxmorev.restful.eshop.annotation.PaymentProvider;

import javax.persistence.*;
import java.util.*;
@Data
@Entity
@Table(name = "customer_order")
@JsonIgnoreProperties(ignoreUnknown = true)
public class CustomerOrder extends AbstractEntity {

    @Version
    @Column(name = "VERSION")
    protected int version;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name="date_of_creation", nullable = false, updatable = false)
    @org.hibernate.annotations.CreationTimestamp
    private Date dateOfCreation;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 32)
    private CustomerOrderStatus status;

    @Enumerated(EnumType.STRING)
    @Column(name = "payment_provider", length = 8)
    private PaymentProvider paymentProvider;

    @Column(name = "paymentID")
    private String paymentID;

    @ManyToOne(optional=false)
    @JoinColumn(name="customer_id", referencedColumnName = "id", foreignKey = @ForeignKey(name = "FK_ORDER_CUSTOMER"))
    private Customer customer;

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "customerOrder", orphanRemoval=true, targetEntity=Purchase.class, fetch = FetchType.LAZY)
    @org.hibernate.annotations.BatchSize(size=5)
    @org.hibernate.annotations.OrderBy(clause = "branch.id asc")
    private List<Purchase> purchases = new ArrayList<>();

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof CustomerOrder)) return false;
        if (!super.equals(o)) return false;
        CustomerOrder that = (CustomerOrder) o;
        return getVersion() == that.getVersion() &&
                getDateOfCreation().equals(that.getDateOfCreation()) &&
                getStatus() == that.getStatus() &&
                Objects.equals(getPaymentProvider(), that.getPaymentProvider() ) &&
                Objects.equals(getPaymentID(), that.getPaymentID()) &&
                Objects.equals(getCustomer().getId(), that.getCustomer().getId());
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), getVersion(), getDateOfCreation(), getStatus(), getPaymentProvider(), getPaymentID(), getCustomer().getId());
    }
}
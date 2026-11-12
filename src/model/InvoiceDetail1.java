package model;

import java.math.BigDecimal;

public class InvoiceDetail1 {
    private int id;
    private Invoice1 invoice;
    private Product1 product;
    private int quantity;
    private BigDecimal unitPrice;

    public InvoiceDetail1() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Invoice1 getInvoice() {
        return invoice;
    }

    public void setInvoice(Invoice1 invoice) {
        this.invoice = invoice;
    }

    public Product1 getProduct() {
        return product;
    }

    public void setProduct(Product1 product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }
}

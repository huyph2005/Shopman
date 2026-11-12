package model;

import java.util.Date;

public class Invoice1 {
    private int id;
    private String code;
    private Date orderDate;
    private String status;
    private Customer1 customer;
    private Address1 shippingAddress;
    private SalesStaff1 salesStaff;
    private DeliveryStaff1 deliveryStaff;

    public Invoice1() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public Date getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Customer1 getCustomer() {
        return customer;
    }

    public void setCustomer(Customer1 customer) {
        this.customer = customer;
    }

    public Address1 getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(Address1 shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public SalesStaff1 getSalesStaff() {
        return salesStaff;
    }

    public void setSalesStaff(SalesStaff1 salesStaff) {
        this.salesStaff = salesStaff;
    }

    public DeliveryStaff1 getDeliveryStaff() {
        return deliveryStaff;
    }

    public void setDeliveryStaff(DeliveryStaff1 deliveryStaff) {
        this.deliveryStaff = deliveryStaff;
    }
}

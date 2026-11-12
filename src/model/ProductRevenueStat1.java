package model;

import java.math.BigDecimal;

public class ProductRevenueStat1 extends Product1 {
    private int totalQuantity;
    private BigDecimal totalRevenue;

    public ProductRevenueStat1() {
    }

    public int getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(int totalQuantity) {
        this.totalQuantity = totalQuantity;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
}

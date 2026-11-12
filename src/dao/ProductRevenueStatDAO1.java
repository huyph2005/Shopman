package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import model.ProductRevenueStat1;

public class ProductRevenueStatDAO1 extends DAO1 {

    public ProductRevenueStatDAO1() {
        super();
    }

    /**
     * Thống kê doanh thu các mặt hàng trong các hóa đơn đã giao (DELIVERED) có ngày đặt thuộc [startDate, endDate],
     * sắp xếp theo doanh thu giảm dần.
     */
    public ProductRevenueStat1[] getProductRevenueStat(Date startDate, Date endDate) {
        ArrayList<ProductRevenueStat1> result = new ArrayList<>();
        String sql = "SELECT p.id, p.code, p.name, SUM(d.quantity) AS totalQuantity,"
                + " SUM(d.quantity * d.unitPrice) AS totalRevenue"
                + " FROM tblInvoiceDetail1 d"
                + " JOIN tblInvoice1 i ON d.tblInvoice1id = i.id"
                + " JOIN tblProduct1 p ON d.tblProduct1id = p.id"
                + " WHERE i.status = 'DELIVERED' AND i.orderDate BETWEEN ? AND ?"
                + " GROUP BY p.id"
                + " ORDER BY totalRevenue DESC";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setDate(1, new java.sql.Date(startDate.getTime()));
            ps.setDate(2, new java.sql.Date(endDate.getTime()));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductRevenueStat1 stat = new ProductRevenueStat1();
                stat.setId(rs.getInt("id"));
                stat.setCode(rs.getString("code"));
                stat.setName(rs.getString("name"));
                stat.setTotalQuantity(rs.getInt("totalQuantity"));
                stat.setTotalRevenue(rs.getBigDecimal("totalRevenue"));
                result.add(stat);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result.toArray(new ProductRevenueStat1[0]);
    }
}

package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import model.Customer1;
import model.FullName1;
import model.Invoice1;
import model.InvoiceDetail1;
import model.Product1;

public class InvoiceDetailDAO1 extends DAO1 {

    public InvoiceDetailDAO1() {
        super();
    }

    /**
     * Các lần giao dịch của một mặt hàng trong các hóa đơn đã giao (DELIVERED) có ngày đặt thuộc [startDate, endDate].
     * Mỗi InvoiceDetail1 chứa Invoice1 (mã, ngày, khách hàng) và Product1.
     */
    public InvoiceDetail1[] getInvoiceDetailOfProduct(Product1 product, Date startDate,
            Date endDate) {
        ArrayList<InvoiceDetail1> result = new ArrayList<>();
        String sql = "SELECT d.id, d.quantity, d.unitPrice,"
                + " i.id AS invoiceId, i.code, i.orderDate,"
                + " m.id AS memberId, m.firstName, m.middleName, m.lastName"
                + " FROM tblInvoiceDetail1 d"
                + " JOIN tblInvoice1 i ON d.tblInvoice1id = i.id"
                + " JOIN tblMember1 m ON i.tblCustomer1id = m.id"
                + " WHERE d.tblProduct1id = ? AND i.status = 'DELIVERED'"
                + " AND i.orderDate BETWEEN ? AND ?"
                + " ORDER BY i.orderDate, i.code";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, product.getId());
            ps.setDate(2, new java.sql.Date(startDate.getTime()));
            ps.setDate(3, new java.sql.Date(endDate.getTime()));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                FullName1 fullName = new FullName1();
                fullName.setFirstName(rs.getString("firstName"));
                fullName.setMiddleName(rs.getString("middleName"));
                fullName.setLastName(rs.getString("lastName"));
                Customer1 customer = new Customer1();
                customer.setId(rs.getInt("memberId"));
                customer.setFullName(fullName);
                Invoice1 invoice = new Invoice1();
                invoice.setId(rs.getInt("invoiceId"));
                invoice.setCode(rs.getString("code"));
                invoice.setOrderDate(rs.getDate("orderDate"));
                invoice.setCustomer(customer);
                InvoiceDetail1 detail = new InvoiceDetail1();
                detail.setId(rs.getInt("id"));
                detail.setQuantity(rs.getInt("quantity"));
                detail.setUnitPrice(rs.getBigDecimal("unitPrice"));
                detail.setInvoice(invoice);
                detail.setProduct(product);
                result.add(detail);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result.toArray(new InvoiceDetail1[0]);
    }
}

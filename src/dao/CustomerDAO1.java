package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import model.Address1;
import model.Customer1;
import model.FullName1;
import org.mindrot.jbcrypt.BCrypt;

public class CustomerDAO1 extends DAO1 {

    public CustomerDAO1() {
        super();
    }

    /**
     * Lưu khách hàng mới vào tblAddress1, tblMember1, tblCustomer1 trong cùng một transaction.
     * Mật khẩu được băm bằng bcrypt; mã khách hàng ghép từ id thành viên nên không lưu.
     * @return true nếu lưu thành công
     */
    public boolean addCustomer(Customer1 customer) {
        boolean result = false;
        String sqlAddress = "INSERT INTO tblAddress1(houseNumber, street, ward,"
                + " district, city) VALUES (?, ?, ?, ?, ?)";
        String sqlMember = "INSERT INTO tblMember1(username, password, firstName,"
                + " middleName, lastName, email, tel, tblAddress1id)"
                + " VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        String sqlCustomer = "INSERT INTO tblCustomer1(tblMember1id) VALUES (?)";
        try {
            con.setAutoCommit(false);

            // 1. lưu địa chỉ vào tblAddress1, lấy id vừa sinh
            Address1 address = customer.getAddress();
            PreparedStatement ps = con.prepareStatement(sqlAddress,
                    Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, address.getHouseNumber());
            ps.setString(2, address.getStreet());
            ps.setString(3, address.getWard());
            ps.setString(4, address.getDistrict());
            ps.setString(5, address.getCity());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                address.setId(rs.getInt(1));
            }

            // 2. lưu thành viên vào tblMember1, mật khẩu được băm bằng bcrypt
            FullName1 fullName = customer.getFullName();
            ps = con.prepareStatement(sqlMember, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, customer.getUsername());
            ps.setString(2, BCrypt.hashpw(customer.getPassword(), BCrypt.gensalt()));
            ps.setString(3, fullName.getFirstName());
            ps.setString(4, fullName.getMiddleName());
            ps.setString(5, fullName.getLastName());
            ps.setString(6, customer.getEmail());
            ps.setString(7, customer.getTel());
            ps.setInt(8, address.getId());
            ps.executeUpdate();
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                customer.setId(rs.getInt(1));
            }

            // 3. lưu khách hàng vào tblCustomer1; mã khách hàng là "KH" + id đủ 5 chữ số
            ps = con.prepareStatement(sqlCustomer);
            ps.setInt(1, customer.getId());
            ps.executeUpdate();
            customer.setCustomerCode(String.format("KH%05d", customer.getId()));

            con.commit();
            result = true;
        } catch (Exception e) {
            e.printStackTrace();
            try {
                con.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return result;
    }
}

package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Customer1;
import model.FullName1;
import model.Manager1;
import model.Member1;
import model.SalesStaff1;
import model.Staff1;
import org.mindrot.jbcrypt.BCrypt;

public class MemberDAO1 extends DAO1 {

    public MemberDAO1() {
        super();
    }

    /**
     * Kiểm tra email, tên đăng nhập, số điện thoại của thành viên đã được sử dụng chưa.
     * @return tên trường bị trùng ("email", "username" hoặc "tel"), null nếu không trùng
     */
    public String checkMemberExist(Member1 member) {
        String result = null;
        String sql = "SELECT email, username, tel FROM tblMember1"
                + " WHERE email = ? OR username = ? OR tel = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, member.getEmail());
            ps.setString(2, member.getUsername());
            ps.setString(3, member.getTel());
            ResultSet rs = ps.executeQuery();
            boolean email = false, username = false, tel = false;
            while (rs.next()) {
                if (rs.getString("email").equalsIgnoreCase(member.getEmail())) {
                    email = true;
                }
                if (rs.getString("username").equalsIgnoreCase(member.getUsername())) {
                    username = true;
                }
                if (rs.getString("tel").equals(member.getTel())) {
                    tel = true;
                }
            }
            // thứ tự như ngoại lệ 3, 4, 5: email, tên đăng nhập, số điện thoại
            if (email) {
                result = "email";
            } else if (username) {
                result = "username";
            } else if (tel) {
                result = "tel";
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * Đăng nhập: tìm thành viên theo tên đăng nhập, so mật khẩu nhập vào với mật khẩu đã băm bằng bcrypt.
     * @return đối tượng Manager1, SalesStaff1 hoặc Customer1; null nếu sai tên đăng nhập hoặc mật khẩu
     */
    public Member1 checkLogin(String username, String password) {
        Member1 result = null;
        String sql = "SELECT m.*, s.staffCode, s.position FROM tblMember1 m"
                + " LEFT JOIN tblStaff1 s ON s.tblMember1id = m.id"
                + " WHERE m.username = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && BCrypt.checkpw(password, rs.getString("password"))) {
                String position = rs.getString("position");
                if (position != null) {
                    // nhân viên: position là MANAGER hoặc SALES_STAFF
                    Staff1 staff = position.equals("MANAGER") ? new Manager1() : new SalesStaff1();
                    staff.setStaffCode(rs.getString("staffCode"));
                    staff.setPosition(position);
                    result = staff;
                } else {
                    // khách hàng: mã khách hàng là "KH" + id đủ 5 chữ số
                    Customer1 customer = new Customer1();
                    customer.setCustomerCode(String.format("KH%05d", rs.getInt("id")));
                    result = customer;
                }
                result.setId(rs.getInt("id"));
                result.setUsername(rs.getString("username"));
                result.setEmail(rs.getString("email"));
                result.setTel(rs.getString("tel"));
                FullName1 fullName = new FullName1();
                fullName.setFirstName(rs.getString("firstName"));
                fullName.setMiddleName(rs.getString("middleName"));
                fullName.setLastName(rs.getString("lastName"));
                result.setFullName(fullName);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}

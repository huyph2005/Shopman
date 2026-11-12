package dao;

import java.sql.Connection;
import java.sql.DriverManager;

/** Lớp cha của các lớp DAO: giữ một kết nối dùng chung tới cơ sở dữ liệu shopman. */
public class DAO1 {
    protected static Connection con;

    public DAO1() {
        if (con == null) {
            // sửa đường dẫn và tài khoản MySQL cho đúng với máy cài đặt
            String dbUrl = "jdbc:mysql://localhost:3306/shopman";
            String dbClass = "com.mysql.cj.jdbc.Driver";
            try {
                Class.forName(dbClass);
                con = DriverManager.getConnection(dbUrl, "root", "");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}

# ShopMan – Hệ thống quản lý bán hàng bách hóa trực tuyến

Mã nguồn pha cài đặt của bài tập lớn Phân tích thiết kế hệ thống thông tin (đề số 35), gồm hai module:

- Đăng ký thành viên (khách hàng)
- Xem thống kê mặt hàng theo doanh thu (nhân viên quản lý)

Ứng dụng web Java dùng JSP + DAO: các trang JSP gọi trực tiếp lớp DAO, không dùng Servlet. Tên trang, lớp, phương thức
và thành phần giao diện giữ đúng như sơ đồ lớp chi tiết của báo cáo.

Theo quy ước đặt tên của học phần, tên lớp, tên bảng và tên trang mang hậu tố 1 (chữ số cuối của mã sinh viên B23DCAT131), ví dụ lớp `Member1`, bảng `tblMember1`, trang `HomeView1.jsp`.

## Mục lục

1. [Chức năng](#chức-năng)
2. [Kiến trúc](#kiến-trúc)
3. [Cấu trúc thư mục](#cấu-trúc-thư-mục)
4. [Cơ sở dữ liệu](#cơ-sở-dữ-liệu)
5. [Phần mềm](#phần-mềm)
6. [Cài đặt và chạy](#cài-đặt-và-chạy)
7. [Tài khoản mẫu](#tài-khoản-mẫu)
8. [Chạy thử](#chạy-thử)


## Chức năng

### Đăng nhập, đăng xuất

- `LoginView1.jsp` nhận tên đăng nhập và mật khẩu, `doLogin1.jsp` gọi `MemberDAO1.checkLogin()`.
- Mật khẩu được so với chuỗi băm bcrypt lưu trong `tblMember1`.
- Đăng nhập đúng: thông tin thành viên được lưu vào session.
  - Nhân viên quản lý vào `ManagerHomeView1.jsp`.
  - Khách hàng và nhân viên bán hàng vào trang chủ `HomeView1.jsp` (gói nhân viên bán hàng chưa có trang riêng, nằm ngoài hai module).
- Sai tên đăng nhập hoặc mật khẩu: hiện "Sai tên đăng nhập hoặc mật khẩu!".
- Các trang của nhân viên quản lý kiểm tra session; chưa đăng nhập hoặc hết phiên thì quay về trang đăng nhập với thông báo "Hết phiên làm việc, vui lòng đăng nhập lại!".
- `doLogout1.jsp` hủy session rồi về trang chủ.

### Module 1: Đăng ký thành viên

Luồng trang:

```
HomeView1.jsp ──click "Đăng ký"──> RegisterView1.jsp ──click "Đăng ký"──> doRegister1.jsp
                                         │                                   │
                                   click "Huỷ"                     ┌─────────┴──────────┐
                                         ▼                         ▼                    ▼
                                   HomeView1.jsp            có lỗi: quay lại      "Đăng ký thành công!"
                                                            RegisterView1.jsp     click OK → HomeView1.jsp
```

Thông tin nhập: họ, tên đệm, tên, tên đăng nhập, mật khẩu, nhập lại mật khẩu, email, số điện thoại, số nhà, đường, phường/xã, quận/huyện, tỉnh/thành phố. Tất cả bắt buộc, trừ tên đệm.

`doRegister1.jsp` kiểm tra lần lượt theo thứ tự dưới đây và dừng ở lỗi đầu tiên:

| Thứ tự | Trường hợp | Thông báo | Vị trí thông báo |
|---|---|---|---|
| 1 | Thiếu thông tin bắt buộc | Vui lòng nhập đầy đủ các thông tin bắt buộc | Đầu form |
| 2 | Email sai định dạng | Email không đúng định dạng | Dưới ô email |
| 3 | Mật khẩu nhập lại không khớp | Mật khẩu nhập lại không khớp (xóa trống hai ô mật khẩu) | Dưới ô mật khẩu |
| 4 | Email đã được dùng | Email đã được sử dụng, vui lòng nhập email khác | Dưới ô email |
| 5 | Tên đăng nhập đã được dùng | Tên đăng nhập đã được sử dụng, vui lòng chọn tên khác | Dưới ô tên đăng nhập |
| 6 | Số điện thoại đã được dùng | Số điện thoại đã được sử dụng, vui lòng nhập số khác | Dưới ô số điện thoại |
| 7 | Lưu vào cơ sở dữ liệu bị lỗi | Lưu thông tin không thành công, vui lòng thử lại | Đầu form |

Khi có lỗi, các ô đã nhập được giữ nguyên (trừ hai ô mật khẩu ở trường hợp 3).

Kiểm tra trùng (trường hợp 4 – 6) do `MemberDAO1.checkMemberExist()` làm bằng một câu truy vấn trên `tblMember1`.

Lưu thông tin do `CustomerDAO1.addCustomer()` làm:

1. Thêm địa chỉ vào `tblAddress1`, lấy id vừa sinh.
2. Thêm thành viên vào `tblMember1` (mật khẩu băm bằng `BCrypt.hashpw()`), khóa ngoại `tblAddress1id` là id ở bước 1.
3. Thêm khách hàng vào `tblCustomer1` với mã khách hàng `KH` + id thành viên đủ 5 chữ số, ví dụ `KH00006`.

Ba lệnh chạy trong cùng một transaction: thành công cả ba thì `commit()`, có lỗi thì `rollback()`, nên không bao giờ chỉ lưu được một phần.

### Module 2: Xem thống kê mặt hàng theo doanh thu

Luồng trang:

```
LoginView1.jsp → ManagerHomeView1.jsp → SelectReportView1.jsp → SelectDateRangeView1.jsp
   (binhtt)       click "Xem báo cáo"     click "Thống kê mặt      chọn ngày bắt đầu, ngày kết thúc,
                                           hàng theo doanh thu"    click "Xem thống kê"
                                                                           │
                                                                           ▼
                  TransactionDetailView1.jsp <──click tên mặt hàng── ProductRevenueStatView1.jsp
                  click "Quay lại" ─────────────────────────────────────────▲
```

- `ProductRevenueStatView1.jsp` gọi `ProductRevenueStatDAO1.getProductRevenueStat(startDate, endDate)`.
  - Chỉ tính hóa đơn đã giao (`status = 'DELIVERED'`) có ngày đặt trong khoảng đã chọn, kể cả hai ngày đầu và cuối.
  - Mỗi dòng gồm mã hàng, tên hàng, tổng số lượng bán, doanh thu (tổng số lượng × đơn giá), sắp xếp theo doanh thu giảm dần.
  - Dòng cuối là tổng cộng số lượng và doanh thu.
- Click tên một mặt hàng: `TransactionDetailView1.jsp` gọi `InvoiceDetailDAO1.getInvoiceDetailOfProduct(product, startDate, endDate)`.
  - Hiện từng lần mặt hàng đó được bán: mã hóa đơn, ngày, khách hàng, số lượng, đơn giá, thành tiền, sắp xếp theo ngày.
  - Dòng cuối là tổng số lượng và tổng thành tiền.
- Khoảng thời gian và kết quả thống kê được giữ trong session, nên "Quay lại" hiện lại đúng bảng thống kê vừa xem.

Các trường hợp lỗi:

| Trường hợp | Thông báo |
|---|---|
| Chưa chọn đủ hai ngày | Vui lòng chọn ngày bắt đầu và ngày kết thúc |
| Ngày kết thúc không sau ngày bắt đầu | Ngày kết thúc phải sau ngày bắt đầu |
| Không có hóa đơn đã giao trong khoảng đó | Không có dữ liệu thống kê trong khoảng thời gian đã chọn (giữ nguyên hai ngày đã chọn) |

## Kiến trúc

```
Trình duyệt ──HTTPS (cổng 8443)──> Apache Tomcat 10.1 ──JDBC──> MySQL Server 8.0
                                   ┌────────────────────┐        (cơ sở dữ liệu shopman)
                                   │ view: trang JSP    │
                                   │   ↓ gọi phương thức│
                                   │ dao: lớp DAO       │
                                   │   ↓ dùng           │
                                   │ model: lớp thực thể│
                                   └────────────────────┘
```

| Gói | Vai trò |
|---|---|
| `view` | Trang JSP: hiển thị giao diện, nhận dữ liệu nhập, gọi DAO, chuyển trang |
| `dao` | Truy xuất cơ sở dữ liệu. `DAO1` giữ kết nối dùng chung `con` (protected static); các lớp DAO con kế thừa `DAO1`, hàm khởi tạo gọi `super()` nên đều có sẵn kết nối |
| `model` | Lớp thực thể: thuộc tính private, phương thức get/set |

- Mọi câu SQL dùng `PreparedStatement` với tham số `?`, không ghép chuỗi trực tiếp.
- Dữ liệu hiển thị ra trang được mã hóa ký tự HTML bằng `<c:out>` hoặc `fn:escapeXml()` của JSTL.
- `web/WEB-INF/web.xml` khai báo `CONFIDENTIAL` nên Tomcat bắt buộc dùng HTTPS.

## Cấu trúc thư mục

```
ShopMan/
├── build.bat                     biên dịch và đóng gói ShopMan.war
├── db/
│   └── shopman.sql               tạo cơ sở dữ liệu shopman (13 bảng) và dữ liệu mẫu
├── src/
│   ├── dao/                      DAO1, MemberDAO1, CustomerDAO1,
│   │                             ProductRevenueStatDAO1, InvoiceDetailDAO1
│   └── model/                    Member1, Customer1, Staff1, Manager1, SalesStaff1,
│                                 DeliveryStaff1, FullName1, Address1, Product1,
│                                 Invoice1, InvoiceDetail1, ProductRevenueStat1
└── web/
    ├── index1.jsp                trang mặc định, chuyển tới HomeView1.jsp
    ├── style.css
    ├── WEB-INF/web.xml           cấu hình UTF-8, trang mặc định, bắt buộc HTTPS
    └── view/
        ├── member/               LoginView1.jsp, doLogin1.jsp, doLogout1.jsp
        ├── customer/             HomeView1.jsp, RegisterView1.jsp, doRegister1.jsp
        └── manager/              ManagerHomeView1.jsp, SelectReportView1.jsp,
                                  SelectDateRangeView1.jsp, ProductRevenueStatView1.jsp,
                                  TransactionDetailView1.jsp
```

Trang có tiền tố `do` (`doLogin1.jsp`, `doRegister1.jsp`, `doLogout1.jsp`) chỉ xử lý dữ liệu rồi chuyển trang, không có giao diện riêng, trừ thông báo "Đăng ký thành công!".

## Cơ sở dữ liệu

`db/shopman.sql` tạo cơ sở dữ liệu `shopman` (utf8mb4) gồm 13 bảng:

| Nhóm | Bảng |
|---|---|
| Thành viên | `tblAddress1`, `tblMember1`, `tblCustomer1`, `tblStaff1`, `tblDeliveryStaff1` |
| Hàng hóa | `tblCategory1`, `tblProduct1` |
| Nhập hàng | `tblSupplier1`, `tblSupplierProduct1`, `tblImportReceipt1`, `tblImportDetail1` |
| Bán hàng | `tblInvoice1`, `tblInvoiceDetail1` |

- Khóa chính là cột `id` tự tăng; khóa ngoại đặt tên `tbl<Bảng>1id`, ví dụ `tblMember1id`.
- `tblStaff1.position` phân biệt nhân viên quản lý (`MANAGER`) và nhân viên bán hàng (`SALES_STAFF`).
- `tblInvoice1.status` là trạng thái hóa đơn: `PENDING` (chờ duyệt), `REJECTED` (bị từ chối), `DELIVERING` (đang giao), `DELIVERED` (đã giao).
- `username`, `email`, `tel` của `tblMember1` là duy nhất.

Script xóa cơ sở dữ liệu `shopman` cũ (nếu có) rồi tạo lại, nên chạy lại bao nhiêu lần cũng được để đưa dữ liệu về như ban đầu.

## Phần mềm

| Phần mềm | Dùng để |
|---|---|
| Eclipse Temurin 21 (OpenJDK) | Biên dịch mã Java, có sẵn `keytool` để tạo chứng chỉ HTTPS |
| Apache Tomcat 10.1 | Chạy ứng dụng web |
| MySQL Community Server 8.0 | Lưu cơ sở dữ liệu |
| Visual Studio Code (tùy chọn) | Xem và sửa mã nguồn |

Thư viện, chép vào thư mục `lib` của Tomcat:

| File | Dùng để |
|---|---|
| `jakarta.servlet.jsp.jstl-api-3.0.2.jar`, `jakarta.servlet.jsp.jstl-3.0.1.jar` | Thẻ JSTL `<c:...>`, `<fmt:...>` trong trang JSP |
| `mysql-connector-j-8.4.0.jar` | Kết nối Java tới MySQL (JDBC) |
| `jbcrypt-0.4.jar` | Băm và kiểm tra mật khẩu bằng bcrypt |

## Cài đặt và chạy

Các lệnh dưới đây gõ trong **Command Prompt (cmd)**, đứng ở thư mục `ShopMan`.

**Bước 1. Tạo cơ sở dữ liệu**

```
mysql -u root -p < db\shopman.sql
```

Nhập mật khẩu tài khoản root của MySQL khi được hỏi. Có thể dùng MySQL Workbench thay cho lệnh trên: File → Open SQL Script → chọn `db/shopman.sql` → Execute.

**Bước 2. Sửa tài khoản MySQL**

Mở `src/dao/DAO1.java`, sửa đường dẫn, tên tài khoản và mật khẩu MySQL cho đúng với máy cài đặt:

```java
String dbUrl = "jdbc:mysql://localhost:3306/shopman";
...
con = DriverManager.getConnection(dbUrl, "root", "");   // "root" là tài khoản, "" là mật khẩu
```

**Bước 3. Biên dịch và đóng gói**

```
set CATALINA_HOME=C:\apache-tomcat-10.1
build.bat
copy ShopMan.war %CATALINA_HOME%\webapps\
```

Thay `C:\apache-tomcat-10.1` bằng thư mục Tomcat trên máy. `build.bat` biên dịch `src/model`, `src/dao` vào `WEB-INF/classes`, chép thư mục `web` rồi đóng gói thành `ShopMan.war`.

**Bước 4. Cấu hình HTTPS** (chỉ làm một lần)

Tạo chứng chỉ bằng keytool có sẵn trong JDK:

```
keytool -genkeypair -alias tomcat -keyalg RSA -keysize 2048 -validity 365 -dname "CN=localhost" -keystore %CATALINA_HOME%\conf\shopman.p12 -storetype PKCS12 -storepass changeit
```

Thêm connector vào `conf/server.xml` của Tomcat, bên trong thẻ `<Service name="Catalina">`:

```xml
<Connector port="8443" protocol="org.apache.coyote.http11.Http11NioProtocol" maxThreads="150" SSLEnabled="true">
    <SSLHostConfig>
        <Certificate certificateKeystoreFile="conf/shopman.p12" certificateKeystorePassword="changeit" type="RSA" />
    </SSLHostConfig>
</Connector>
```

`web/WEB-INF/web.xml` bắt buộc dùng HTTPS: vào bằng `http://localhost:8080/ShopMan/` thì Tomcat tự chuyển sang cổng 8443.

**Bước 5. Chạy**

```
%CATALINA_HOME%\bin\startup.bat
```

Mở trình duyệt, vào `https://localhost:8443/ShopMan/`. Chứng chỉ tự tạo nên trình duyệt sẽ cảnh báo, chọn "Nâng cao" rồi "Tiếp tục truy cập localhost".

Dừng Tomcat bằng `%CATALINA_HOME%\bin\shutdown.bat`. Mỗi lần sửa mã nguồn thì chạy lại bước 3 (Tomcat tự nạp lại `ShopMan.war` mới).

## Tài khoản mẫu

| Tên đăng nhập | Mật khẩu | Vai trò |
|---|---|---|
| binhtt | Binh@12345 | Nhân viên quản lý (Trần Thị Bình) |
| namhv | Nam@12345 | Nhân viên bán hàng |
| baovq, hoalt, ducpm | Abc@12345 | Khách hàng (Vũ Quốc Bảo, Lê Thị Hoa, Phạm Minh Đức) |

Mật khẩu trong cơ sở dữ liệu là chuỗi băm bcrypt, không lưu dạng gốc.

Dữ liệu mẫu có 7 hóa đơn; chỉ 3 hóa đơn đã giao trong tháng 9/2026 (HD0921, HD0957, HD1003) được tính vào thống kê tháng 9:

| Hóa đơn | Ngày đặt | Trạng thái | Có được tính cho tháng 9/2026 |
|---|---|---|---|
| HD0890 | 28/08/2026 | Đã giao | Không (ngoài khoảng thời gian) |
| HD0921, HD0957, HD1003 | 03, 12, 25/09/2026 | Đã giao | Có |
| HD1010 | 28/09/2026 | Đang giao | Không |
| HD1012 | 29/09/2026 | Chờ duyệt | Không |
| HD1015 | 30/09/2026 | Bị từ chối | Không |

## Chạy thử

### Đăng ký thành viên

Từ trang chủ, click "Đăng ký" rồi nhập:

| Trường | Giá trị |
|---|---|
| Họ / Tên đệm / Tên | Nguyễn / Văn / An |
| Tên đăng nhập | annv |
| Mật khẩu / Nhập lại mật khẩu | An@12345 / An@12345 |
| Email | annv@gmail.com |
| Số điện thoại | 0912345678 |
| Số nhà / Đường | 96A / Trần Phú |
| Phường – Quận – Tỉnh/TP | Mộ Lao – Hà Đông – Hà Nội |

| Cách thử | Kết quả đúng |
|---|---|
| Nhập như bảng trên, click "Đăng ký" | "Đăng ký thành công!", khách hàng mới có mã KH00006; click OK về trang chủ |
| Click "Huỷ" | Về trang chủ, không lưu gì |
| Nhập lại mật khẩu là An@1234 | "Mật khẩu nhập lại không khớp", hai ô mật khẩu bị xóa trống |
| Đăng ký lần hai với cùng email annv@gmail.com | "Email đã được sử dụng, vui lòng nhập email khác" |
| Đổi email khác, giữ tên đăng nhập annv | "Tên đăng nhập đã được sử dụng, vui lòng chọn tên khác" |
| Đổi email và tên đăng nhập khác, giữ số 0912345678 | "Số điện thoại đã được sử dụng, vui lòng nhập số khác" |
| Để trống ô Tỉnh/Thành phố | "Vui lòng nhập đầy đủ các thông tin bắt buộc" |
| Email là annv.gmail.com | "Email không đúng định dạng" |
| Đăng nhập bằng annv / An@12345 | Đăng nhập thành công, vào trang chủ |

Muốn thử lại từ đầu (để annv lại là tài khoản mới) thì chạy lại `db/shopman.sql`.

### Xem thống kê mặt hàng theo doanh thu

Đăng nhập bằng `binhtt` / `Binh@12345` → "Xem báo cáo" → "Thống kê mặt hàng theo doanh thu".

| Cách thử | Kết quả đúng |
|---|---|
| Từ 01/09/2026 đến 30/09/2026 | 4 mặt hàng như bảng dưới, tổng 173 sản phẩm, 10.772.000 đ |
| Click dòng Sữa tươi Vinamilk hộp 1L | 3 lần giao dịch HD0921, HD0957, HD1003, tổng 96 sản phẩm, 3.072.000 đ; "Quay lại" hiện lại bảng thống kê |
| Từ 30/09/2026 đến 01/09/2026 | "Ngày kết thúc phải sau ngày bắt đầu" |
| Từ 01/01/2020 đến 31/01/2020 | "Không có dữ liệu thống kê trong khoảng thời gian đã chọn" |

Kết quả thống kê tháng 9/2026:

| STT | Mã hàng | Tên hàng | SL bán | Doanh thu (đ) |
|---|---|---|---|---|
| 1 | MH005 | Gạo ST25 túi 5kg | 25 | 4.500.000 |
| 2 | MH012 | Sữa tươi Vinamilk hộp 1L | 96 | 3.072.000 |
| 3 | MH021 | Dầu ăn Neptune chai 1L | 40 | 1.880.000 |
| 4 | MH033 | Mì Hảo Hảo thùng 30 gói | 12 | 1.320.000 |
| | | Tổng cộng | 173 | 10.772.000 |

Chi tiết giao dịch của Sữa tươi Vinamilk hộp 1L:

| STT | Mã HĐ | Ngày | Khách hàng | SL | Đơn giá | Thành tiền |
|---|---|---|---|---|---|---|
| 1 | HD0921 | 03/09/2026 | Vũ Quốc Bảo | 24 | 32.000 | 768.000 |
| 2 | HD0957 | 12/09/2026 | Lê Thị Hoa | 36 | 32.000 | 1.152.000 |
| 3 | HD1003 | 25/09/2026 | Phạm Minh Đức | 36 | 32.000 | 1.152.000 |
| | | | Tổng cộng | 96 | | 3.072.000 |



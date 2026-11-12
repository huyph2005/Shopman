-- Cơ sở dữ liệu ShopMan: 13 bảng theo Bảng 6 và Hình 12 của báo cáo, kèm dữ liệu mẫu.
-- Chạy bằng MySQL Community Server 8.0 trở lên:  mysql -u root -p < shopman.sql
-- Mật khẩu các tài khoản mẫu được băm bằng bcrypt:
--   binhtt / Binh@12345 (nhân viên quản lý), namhv / Nam@12345 (nhân viên bán hàng),
--   baovq, hoalt, ducpm / Abc@12345 (khách hàng)

SET NAMES utf8mb4;
DROP DATABASE IF EXISTS shopman;
CREATE DATABASE shopman CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE shopman;

CREATE TABLE tblAddress1 (
    id integer(10) NOT NULL AUTO_INCREMENT,
    houseNumber varchar(255) NOT NULL,
    street varchar(255) NOT NULL,
    ward varchar(255) NOT NULL,
    district varchar(255) NOT NULL,
    city varchar(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE tblMember1 (
    id integer(10) NOT NULL AUTO_INCREMENT,
    username varchar(255) NOT NULL UNIQUE,
    password varchar(255) NOT NULL,
    firstName varchar(255) NOT NULL,
    middleName varchar(255) NULL,
    lastName varchar(255) NOT NULL,
    email varchar(255) NOT NULL UNIQUE,
    tel varchar(20) NOT NULL UNIQUE,
    tblAddress1id integer(10) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (tblAddress1id) REFERENCES tblAddress1 (id)
);

CREATE TABLE tblCustomer1 (
    tblMember1id integer(10) NOT NULL,
    customerCode varchar(50) NOT NULL UNIQUE,
    PRIMARY KEY (tblMember1id),
    FOREIGN KEY (tblMember1id) REFERENCES tblMember1 (id)
);

CREATE TABLE tblStaff1 (
    tblMember1id integer(10) NOT NULL,
    staffCode varchar(50) NOT NULL UNIQUE,
    position varchar(50) NOT NULL,
    PRIMARY KEY (tblMember1id),
    FOREIGN KEY (tblMember1id) REFERENCES tblMember1 (id)
);

CREATE TABLE tblDeliveryStaff1 (
    id integer(10) NOT NULL AUTO_INCREMENT,
    name varchar(255) NOT NULL,
    tel varchar(20) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE tblSupplier1 (
    id integer(10) NOT NULL AUTO_INCREMENT,
    code varchar(50) NOT NULL UNIQUE,
    name varchar(255) NOT NULL,
    email varchar(255) NOT NULL,
    tel varchar(20) NOT NULL,
    tblAddress1id integer(10) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (tblAddress1id) REFERENCES tblAddress1 (id)
);

CREATE TABLE tblCategory1 (
    id integer(10) NOT NULL AUTO_INCREMENT,
    name varchar(255) NOT NULL,
    description varchar(255) NULL,
    PRIMARY KEY (id)
);

CREATE TABLE tblProduct1 (
    id integer(10) NOT NULL AUTO_INCREMENT,
    code varchar(50) NOT NULL UNIQUE,
    name varchar(255) NOT NULL,
    unit varchar(50) NOT NULL,
    unitPrice decimal(15, 2) NOT NULL,
    stockQuantity integer(10) NOT NULL,
    description varchar(255) NULL,
    tblCategory1id integer(10) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (tblCategory1id) REFERENCES tblCategory1 (id)
);

CREATE TABLE tblSupplierProduct1 (
    id integer(10) NOT NULL AUTO_INCREMENT,
    tblSupplier1id integer(10) NOT NULL,
    tblProduct1id integer(10) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (tblSupplier1id, tblProduct1id),
    FOREIGN KEY (tblSupplier1id) REFERENCES tblSupplier1 (id),
    FOREIGN KEY (tblProduct1id) REFERENCES tblProduct1 (id)
);

CREATE TABLE tblImportReceipt1 (
    id integer(10) NOT NULL AUTO_INCREMENT,
    code varchar(50) NOT NULL UNIQUE,
    importDate date NOT NULL,
    tblSupplier1id integer(10) NOT NULL,
    tblStaff1id integer(10) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (tblSupplier1id) REFERENCES tblSupplier1 (id),
    FOREIGN KEY (tblStaff1id) REFERENCES tblStaff1 (tblMember1id)
);

CREATE TABLE tblImportDetail1 (
    id integer(10) NOT NULL AUTO_INCREMENT,
    quantity integer(10) NOT NULL,
    importPrice decimal(15, 2) NOT NULL,
    tblImportReceipt1id integer(10) NOT NULL,
    tblProduct1id integer(10) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (tblImportReceipt1id, tblProduct1id),
    FOREIGN KEY (tblImportReceipt1id) REFERENCES tblImportReceipt1 (id),
    FOREIGN KEY (tblProduct1id) REFERENCES tblProduct1 (id)
);

CREATE TABLE tblInvoice1 (
    id integer(10) NOT NULL AUTO_INCREMENT,
    code varchar(50) NOT NULL UNIQUE,
    orderDate date NOT NULL,
    status varchar(50) NOT NULL,
    tblCustomer1id integer(10) NOT NULL,
    tblAddress1id integer(10) NOT NULL,
    tblStaff1id integer(10) NULL,
    tblDeliveryStaff1id integer(10) NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (tblCustomer1id) REFERENCES tblCustomer1 (tblMember1id),
    FOREIGN KEY (tblAddress1id) REFERENCES tblAddress1 (id),
    FOREIGN KEY (tblStaff1id) REFERENCES tblStaff1 (tblMember1id),
    FOREIGN KEY (tblDeliveryStaff1id) REFERENCES tblDeliveryStaff1 (id)
);

CREATE TABLE tblInvoiceDetail1 (
    id integer(10) NOT NULL AUTO_INCREMENT,
    quantity integer(10) NOT NULL,
    unitPrice decimal(15, 2) NOT NULL,
    tblInvoice1id integer(10) NOT NULL,
    tblProduct1id integer(10) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (tblInvoice1id, tblProduct1id),
    FOREIGN KEY (tblInvoice1id) REFERENCES tblInvoice1 (id),
    FOREIGN KEY (tblProduct1id) REFERENCES tblProduct1 (id)
);

-- Dữ liệu mẫu
INSERT INTO tblAddress1 (id, houseNumber, street, ward, district, city) VALUES
    (1, '15', 'Nguyễn Trãi', 'Thượng Đình', 'Thanh Xuân', 'Hà Nội'),
    (2, '27', 'Lê Văn Lương', 'Nhân Chính', 'Thanh Xuân', 'Hà Nội'),
    (3, '12', 'Quang Trung', 'Quang Trung', 'Hà Đông', 'Hà Nội'),
    (4, '8', 'Cầu Giấy', 'Quan Hoa', 'Cầu Giấy', 'Hà Nội'),
    (5, '41', 'Kim Mã', 'Kim Mã', 'Ba Đình', 'Hà Nội'),
    (6, '120', 'Phạm Văn Đồng', 'Cổ Nhuế 1', 'Bắc Từ Liêm', 'Hà Nội');

INSERT INTO tblMember1 (id, username, password, firstName, middleName, lastName, email, tel, tblAddress1id) VALUES
    (1, 'binhtt', '$2a$10$Lbq8kkuICDghvg6sTuydbO1TryxkUd0N9cbmC7NhRiVnvHiM60SC6', 'Bình', 'Thị', 'Trần', 'binhtt@shopman.vn', '0911000001', 1),
    (2, 'namhv', '$2a$10$ZtsiHJcNJpgPo4e/MXV0z.jyLJrzcAuASz3nDFvdQw0a8TsezuBiW', 'Nam', 'Văn', 'Hoàng', 'namhv@shopman.vn', '0911000002', 2),
    (3, 'baovq', '$2a$10$0ckTsqyvO0ZFgfi2P1VPpuP28gOz4My8rTGRCLIwwATIWrguG0Lm2', 'Bảo', 'Quốc', 'Vũ', 'baovq@gmail.com', '0901000003', 3),
    (4, 'hoalt', '$2a$10$0ckTsqyvO0ZFgfi2P1VPpuP28gOz4My8rTGRCLIwwATIWrguG0Lm2', 'Hoa', 'Thị', 'Lê', 'hoalt@gmail.com', '0901000004', 4),
    (5, 'ducpm', '$2a$10$0ckTsqyvO0ZFgfi2P1VPpuP28gOz4My8rTGRCLIwwATIWrguG0Lm2', 'Đức', 'Minh', 'Phạm', 'ducpm@gmail.com', '0901000005', 5);

INSERT INTO tblStaff1 (tblMember1id, staffCode, position) VALUES
    (1, 'NV001', 'MANAGER'),
    (2, 'NV002', 'SALES_STAFF');

INSERT INTO tblCustomer1 (tblMember1id, customerCode) VALUES
    (3, 'KH00003'),
    (4, 'KH00004'),
    (5, 'KH00005');

INSERT INTO tblDeliveryStaff1 (id, name, tel) VALUES
    (1, 'Đỗ Văn Tùng', '0987000001');

INSERT INTO tblSupplier1 (id, code, name, email, tel, tblAddress1id) VALUES
    (1, 'NCC01', 'Công ty TNHH Phân phối Hàng tiêu dùng Hà Nội', 'lienhe@phanphoihn.vn', '0243000001', 6);

INSERT INTO tblCategory1 (id, name, description) VALUES
    (1, 'Lương thực', 'Gạo, ngũ cốc'),
    (2, 'Sữa và đồ uống', NULL),
    (3, 'Gia vị', 'Dầu ăn, nước mắm, nước chấm'),
    (4, 'Thực phẩm khô', 'Mì, miến, phở khô');

INSERT INTO tblProduct1 (id, code, name, unit, unitPrice, stockQuantity, description, tblCategory1id) VALUES
    (1, 'MH005', 'Gạo ST25 túi 5kg', 'túi', 180000.00, 120, NULL, 1),
    (2, 'MH012', 'Sữa tươi Vinamilk hộp 1L', 'hộp', 32000.00, 300, NULL, 2),
    (3, 'MH021', 'Dầu ăn Neptune chai 1L', 'chai', 47000.00, 150, NULL, 3),
    (4, 'MH033', 'Mì Hảo Hảo thùng 30 gói', 'thùng', 110000.00, 80, NULL, 4),
    (5, 'MH040', 'Nước mắm Nam Ngư chai 500ml', 'chai', 38000.00, 90, NULL, 3);

INSERT INTO tblSupplierProduct1 (id, tblSupplier1id, tblProduct1id) VALUES
    (1, 1, 1), (2, 1, 2), (3, 1, 3), (4, 1, 4), (5, 1, 5);

INSERT INTO tblImportReceipt1 (id, code, importDate, tblSupplier1id, tblStaff1id) VALUES
    (1, 'PN001', '2026-08-20', 1, 1);

INSERT INTO tblImportDetail1 (id, quantity, importPrice, tblImportReceipt1id, tblProduct1id) VALUES
    (1, 100, 150000.00, 1, 1),
    (2, 200, 26000.00, 1, 2);

-- Tháng 9/2026 có 3 hóa đơn đã giao (HD0921, HD0957, HD1003) như kịch bản Bảng 4;
-- HD0890 ngoài khoảng thời gian, HD1010 đang giao, HD1012 chờ duyệt, HD1015 bị từ chối nên không được tính.
INSERT INTO tblInvoice1 (id, code, orderDate, status, tblCustomer1id, tblAddress1id, tblStaff1id, tblDeliveryStaff1id) VALUES
    (1, 'HD0890', '2026-08-28', 'DELIVERED', 3, 3, 2, 1),
    (2, 'HD0921', '2026-09-03', 'DELIVERED', 3, 3, 2, 1),
    (3, 'HD0957', '2026-09-12', 'DELIVERED', 4, 4, 2, 1),
    (4, 'HD1003', '2026-09-25', 'DELIVERED', 5, 5, 2, 1),
    (5, 'HD1010', '2026-09-28', 'DELIVERING', 4, 4, 2, 1),
    (6, 'HD1012', '2026-09-29', 'PENDING', 5, 5, NULL, NULL),
    (7, 'HD1015', '2026-09-30', 'REJECTED', 3, 3, 2, NULL);

INSERT INTO tblInvoiceDetail1 (id, quantity, unitPrice, tblInvoice1id, tblProduct1id) VALUES
    (1, 10, 32000.00, 1, 2),
    (2, 24, 32000.00, 2, 2),
    (3, 10, 180000.00, 2, 1),
    (4, 15, 47000.00, 2, 3),
    (5, 36, 32000.00, 3, 2),
    (6, 8, 180000.00, 3, 1),
    (7, 5, 110000.00, 3, 4),
    (8, 36, 32000.00, 4, 2),
    (9, 7, 180000.00, 4, 1),
    (10, 25, 47000.00, 4, 3),
    (11, 7, 110000.00, 4, 4),
    (12, 12, 32000.00, 5, 2),
    (13, 2, 180000.00, 6, 1),
    (14, 3, 110000.00, 7, 4);

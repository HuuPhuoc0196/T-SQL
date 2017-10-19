/*
2.	Tạo View để thống kê số lượng khách hàng của từng quốc gia của khách hàng đã mua ở 2 mức trong suốt, 
	view gồm có 2 cột: Quốc gia và Số lượng khách hàng, đặt tên view như sau:
- ViewThongKeSLKHTheoQGMuc1 trên Northwind
- ViewThongKeSLKHTheoQGMuc2 trên Northwind1

*/
USE Northwind
GO
CREATE VIEW ViewThongKeSLKHTheoQGMuc1 AS
SELECT Country, COUNT(CustomerID) AS SoLuong
FROM Customers
GROUP BY Country
GO

USE Northwind1
GO
CREATE VIEW ViewThongKeSLKHTheoQGMuc2 AS
SELECT Country, COUNT(KH1.CustomerID) AS SoLuong
FROM KH1
GROUP BY Country
UNION 
SELECT Country, COUNT(KH2.CustomerID) AS SoLuong
FROM KH2
GROUP BY Country

/*
3.	Tạo View để thống kê số lượng đơn hàng của từng quốc gia của khách hàng đã mua ở 2 mức trong suốt, 
	view gồm có 2 cột: Quốc gia và Số lượng đơn hàng, đặt tên view như sau:
- ViewThongKeSLDHTheoQGMuc1 trên Northwind
- ViewThongKeSLDHTheoQGMuc2 trên Northwind1 
*/
USE Northwind
GO
CREATE VIEW ViewThongKeSLDHTheoQGMuc1 AS
SELECT Country, COUNT(OrderID) AS SoLuong
FROM Orders, Customers
WHERE Orders.CustomerID = Customers.CustomerID
GROUP BY Country
ORDER BY Country DESC
GO

USE Northwind1
GO
CREATE VIEW ViewThongKeSLDHTheoQGMuc2 AS
SELECT Country, COUNT(DH1.OrderID) AS SoLuong
FROM KH1,DH1
WHERE DH1.CustomerID = KH1.CustomerID
GROUP BY Country
UNION
SELECT Country, COUNT(DH2.OrderID) AS SoLuong
FROM KH2, DH2
WHERE DH2.CustomerID = KH2.CustomerID
GROUP BY Country
GO


/*
4.	Tạo Procedure để in danh sách khách hàng chưa mua đơn hàng nào. 
	Procedure này  không có tham số, đặt tên Proc này ở 2 mức là:
- ProcKHChuaMuaHangMuc1 trên trên Northwind
- ProcKHChuaMuaHangMuc2 trên trên Northwind1
Chạy 2 Proc này ở 2 CSDL để thêm xem kết quả có giống nhau không.

*/

USE Northwind
GO
CREATE PROC ProcKHChuaMuaHangMuc1
AS
SELECT * FROM Customers
WHERE CustomerID NOT IN(
	SELECT Customers.CustomerID 
	FROM Customers, Orders
	WHERE Customers.CustomerID = Orders.CustomerID
)
GO
EXEC ProcKHChuaMuaHangMuc1
GO

USE Northwind1
GO
CREATE PROC ProcKHChuaMuaHangMuc2
AS
SELECT * FROM KH1
WHERE CustomerID NOT IN(
	SELECT KH1.CustomerID 
	FROM KH1, DH1
	WHERE KH1.CustomerID = DH1.CustomerID
)

UNION

SELECT * FROM KH2
WHERE CustomerID NOT IN(
	SELECT KH2.CustomerID 
	FROM KH2, DH2
	WHERE KH2.CustomerID = DH2.CustomerID
)
GO
EXEC ProcKHChuaMuaHangMuc2
GO

/*
5.	Tạo Procedure để thêm dữ liệu khách hàng. Procedure này có 4 tham số vào là: 
	- Mã khách hàng (MaKH hay CustomerID)
	- Tên công ty (TenCongTy hay CompanyName)
	- Thành phố (ThanhPho hay City)
	- Quốc gia (QuocGia hay Country)
Đặt tên Proc này ở 2 mức là:
	- ProcThemKHMuc1 trên trên Northwind
	- ProcThemKHMuc2 trên trên Northwind1
Chạy 2 Proc này ở 2 CSDL để thêm 2 hàng dữ liệu sau:
	Khách hàng 1
	- CustomerID: KH001
	- CompanyName: Công ty 001
	- City: HCMC
	- Country: Vietnam
	Khách hàng 2
	- CustomerID: KH002
	- CompanyName: Công ty 002
	- City: London
	- Country: UK
	Kiểm tra dữ liệu (Select) ở các bảng, phân mảnh đã thêm xem có chính xác không. 

*/
USE Northwind
GO
CREATE PROC ProcThemKHMuc1(@CustomerID nchar(5), @CompanyName nvarchar(40), @City nvarchar(15), @Country nvarchar(15))
AS
	IF(SELECT CustomersID FROM Customers WHERE CustomerID = @CustomerID)
	INSERT INTO Customers(CustomerID, CompanyName, City, Country)
	VALUES(@CustomerID, @CompanyName, @City, @Country)
GO
EXEC ProcThemKHMuc1 'KH001', N'Công ty 001', 'HCMC', 'Vietnam'
GO
EXEC ProcThemKHMuc1 'KH002', N'Công ty 002', 'London', 'UK'
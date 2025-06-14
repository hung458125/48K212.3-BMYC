create database BMYCM 
use BMYCM 
CREATE TABLE Giaovien (
    Magiaovien CHAR(10) PRIMARY KEY Not Null ,
    TenGiaovien VARCHAR(50) NOT NULL,
    Ngaysinh DATE NOT NULL,
	Diachi varchar (50) not null,
    Email VARCHAR(50) UNIQUE NOT NULL,
    Sdt CHAR(10) NOT NULL,
);
CREATE TABLE Lophoc (
    Malophoc CHAR(10) PRIMARY KEY Not Null ,
    Tenlophoc VARCHAR(30) NOT NULL,
    Khunggioday TIME NOT NULL,
	Magiaovien CHAR(10) Not Null ,
    FOREIGN KEY (Magiaovien) REFERENCES Giaovien(Magiaovien),
);
CREATE TABLE Khoahoc (
    Makhoahoc CHAR(10) PRIMARY KEY Not Null,
    Tenkhoahoc VARCHAR(50) NOT NULL,
	Thoigianbatdau Date Not Null, 
	Thoigiankethuc Date Not Null,
	Magiaovien CHAR(10) Not Null ,
    FOREIGN KEY (Magiaovien) REFERENCES Giaovien(Magiaovien)
);
CREATE TABLE Lichday (
    Madangkilichday CHAR(10) PRIMARY KEY Not Null,
	Thoigiandangki date not null ,
	Khunggiohoc datetime not null,
	Magiaovien CHAR(10) Not Null  ,
    Makhoahoc CHAR(10) Not Null,
    Malophoc CHAR(10) Not Null ,
    FOREIGN KEY (Makhoahoc) REFERENCES Khoahoc(Makhoahoc),
    FOREIGN KEY (Malophoc) REFERENCES Lophoc(Malophoc),
	FOREIGN KEY (Magiaovien) REFERENCES Giaovien(Magiaovien)
);
CREATE TABLE Phieuxinnghi (
    Maphieuxinnghi CHAR(10) PRIMARY KEY Not Null,
    Magiaovien CHAR(10) Not Null ,
    Lydoxinnghi Varchar(100) NOT NULL,
	Thoigiannghi date not null ,
	Malophoc char(10) not null, 
	FOREIGN KEY (Malophoc ) REFERENCES Lophoc(Malophoc),
	FOREIGN KEY (Magiaovien) REFERENCES Giaovien(Magiaovien)
);
CREATE TABLE Luong (
    Maluong CHAR(10) PRIMARY KEY Not Null ,
    Magiaovien CHAR(10) Not Null,
    Luongcoban Varchar(20) NOT NULL,
    Motaluong Varchar(50) NOT NULL,
	Hesoluong decimal (10,2) Not Null ,
    FOREIGN KEY (Magiaovien) REFERENCES Giaovien(Magiaovien),
);
CREATE TABLE Taikhoan (
    Mataikhoan CHAR(10) PRIMARY KEY Not Null,
    Tentaikhoan VARCHAR(50) NOT NULL,
    Matkhau VARCHAR(30) NOT NULL,
	Magiaovien char (10) not null,
	FOREIGN KEY (Magiaovien) REFERENCES Giaovien(Magiaovien)
);
CREATE TABLE Bangcap (
    Mabangcap CHAR(10) PRIMARY KEY Not Null ,
    Tenbangcap VARCHAR(50) NOT NULL,
	Magiaovien CHAR (10) not null,
	Ngaycap Date Not Null , 
	FOREIGN KEY (Magiaovien) REFERENCES Giaovien(Magiaovien)
);

-- bảng giáo viên

create procedure giaovien_dumpp 
as
begin 
    declare @i int = 1;

    while @i <= 1000
    begin
        insert into Giaovien (Magiaovien, Tengiaovien, Ngaysinh, Diachi, Email, Sdt)
        values (
            format(@i, 'd10'),  
            'giáo viên ' + cast(@i as varchar(10)), 
            dateadd(year, -round(rand() * 30 + 22, 0), getdate()),  
            'địa chỉ ' + cast(@i as varchar(10)),  
            'email' + cast(@i as varchar(10)) + '@example.com', 
            right('0000000000' + cast(cast(rand() * 10000000000 as bigint) as varchar(10)), 10)
        ); 
        
        set @i = @i + 1;
    end
end;

exec giaovien_dumpp;
select * from giaovien; 
drop procedure giaovien_dumpp;
-- bảng lớp học 
create procedure lophoc_dump 
as
begin
    declare @i int = 1;

    while @i <= 1000
    begin
        insert into Lophoc (Malophoc, Tenlophoc, Khunggioday, Magiaovien)
        values (
            format(@i, 'd10'), 
            'lớp ' + cast(@i as varchar(10)), 
            cast(dateadd(second, 
                cast(rand() * datediff(second, cast('08:00' as time), cast('12:00' as time)) as int), 
                cast('08:00' as time)) as time),  
            format((@i % 1000) + 1, 'd10') 
        );

        set @i = @i + 1;
    end
end;

exec lophoc_dump; 
select * from lophoc; 
drop procedure lophoc_dump;
-- --- bảng khóa học 
create procedure khoahoc_dump 
as
begin
    declare @i int = 1;

    while @i <= 1000
    begin
        insert into Khoahoc (Makhoahoc, Tenkhoahoc, Thoigianbatdau, Thoigiankethuc, Magiaovien)
        values (
            format(@i, 'd10'),  
            'khóa học ' + cast(@i as varchar(10)), 
            dateadd(day, @i, getdate()),  
            dateadd(day, @i + 30, getdate()),  
            format((@i % 1000) + 1, 'd10')  
        );

        set @i = @i + 1;
    end
end;

exec khoahoc_dump;
select * from khoahoc; 
drop procedure khoahoc_dump;
---- bảng lịch dạy 
create procedure lichday_dump 
as
begin
    declare @i int = 1;

    while @i <= 1000
    begin
        insert into Lichday (Madangkilichday, Thoigiandangki, khunggiohoc, Magiaovien, Makhoahoc, Malophoc)
        values (
            format(@i, 'd10'),  
            getdate(),  
            dateadd(hour, (rand() * 4) + 8, cast(getdate() as datetime)),  
            format((@i % 1000) + 1, 'd10'),  
            format((@i % 1000) + 1, 'd10'),  
            format((@i % 1000) + 1, 'd10')   
        );

        set @i = @i + 1;
    end
end;

exec lichday_dump;
select * from lichday; 
drop procedure lichday_dump;

-- bảng phiếu xin nghỉ 
create procedure phieuxinnghi_dump 
as
begin
    declare @i int = 1;

    while @i <= 1000
    begin
        insert into Phieuxinnghi (Maphieuxinnghi, Magiaovien, Lydoxinnghi, Thoigiannghi, Malophoc)
        values (
            format(@i, 'd10'),  
            format((@i % 1000) + 1, 'd10'), 
            'lý do nghỉ ' + cast(@i as varchar(10)),  
            dateadd(day, -(@i % 30), getdate()), 
            format((@i % 1000) + 1, 'd10')   
        );

        set @i = @i + 1;
    end
end;

exec phieuxinnghi_dump; 
select * from phieuxinnghi; 
drop procedure phieuxinnghi_dump;
-- -- bảng lương 
create procedure luong_dump 
as
begin
    declare @i int = 1;

    while @i <= 1000
    begin
        insert into Luong (Maluong, Magiaovien, Luongcoban, Motaluong, Hesoluong)
        values (
            format(@i, 'd10'),  
            format((@i % 1000) + 1, 'd10'),  
            cast(3000000 + (rand() * 2000000) as varchar(20)),  
            'mô tả lương ' + cast(@i as varchar(10)),  
            round(rand() * 3 + 1, 2)  
        );

        set @i = @i + 1;
    end
end;

exec luong_dump; 
select * from luong; 
drop procedure luong_dump; 

-- bảng tài khoản 
create procedure taikhoan_dump
as
begin
    declare @i int = 1;

    while @i <= 1000
    begin
        insert into Taikhoan (Mataikhoan, Tentaikhoan, Matkhau, Magiaovien)
        values (
            format(@i, 'd10'),  
            'tài khoản ' + cast(@i as varchar(10)),  
            'matkhau_' + cast(@i as varchar(10)), 
            format((@i % 1000) + 1, 'd10')  
        );

        set @i = @i + 1;
    end
end;

exec taikhoan_dump; 
select * from taikhoan; 
drop procedure taikhoan_dump; 

-- bảng bằng cấp 
create procedure bangcap_dump
as
begin
    declare @i int = 1;
    while @i <= 1000
    begin
        insert into Bangcap (Mabangcap, Tenbangcap, Magiaovien, Ngaycap)
        values (
            format(@i, 'd10'),  
            'bằng cấp ' + cast(@i as varchar(10)), 
            format((@i % 1000) + 1, 'd10'),  
            dateadd(year, -(@i % 5), getdate())  
        );

        set @i = @i + 1;
    end
end;

exec bangcap_dump; 
select * from bangcap; 
drop procedure bangcap_dump;
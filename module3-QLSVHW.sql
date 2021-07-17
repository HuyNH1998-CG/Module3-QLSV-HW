create database quanlysinhvien DEFAULT CHARACTER SET utf8  DEFAULT COLLATE utf8_unicode_ci;
use quanlysinhvien;
create table tblKhoa(
k_ID int primary key,
k_ten nvarchar(20)
);
create table tblLop(
l_ID int primary key,
l_Ten nvarchar(20),
l_Khoa int,
foreign key (l_khoa) references tblKhoa(k_ID)
);
create table tblSinhVien(
sv_Maso int primary key,
sv_Hodem nvarchar(30),
sv_ten nvarchar(15),
sv_Ngaysinh date,
sv_Lop int,
sv_DiemTB double,
foreign key (sv_Lop) references tblLop(l_ID)
);

insert into tblKhoa
value (1, "CNTT"),
(2,"Tài Nguyên"),
(3,"Xây dựng");

insert into tblLop
value (1,"CN01",1),
(2,"TN01",2),
(3,"XD01",3);

insert into tblSinhVien
value (1,"Nguyễn Văn","Tám","2002-09-01",1,8.0),
(2,"Nguyễn Thị","Hà","1990-05-01",2,10.0),
(3,"Nguyễn Tấn","Toàn","1995-12-01",3,5.0);

select sv_Maso,sv_Hodem,sv_ten from tblSinhVien;

select sv_Maso, concat(sv_Hodem, " ", sv_ten) as "Ho ten" from tblSinhVien;

select sv_Maso,sv_Hodem,sv_ten,timestampdiff(year,sv_Ngaysinh,CURDATE()) as tuoi  from tblSinhVien;

select l_ID, l_Ten, l_Khoa from tblLop;

select k_ID, k_Ten from tblKhoa;

select sv_Maso, concat(sv_Hodem, " ", sv_ten) as "Ho ten", l_ten, k_Ten from tblSinhVien
join tblLop
on sv_Lop = l_ID
join tblKhoa
on l_Khoa = k_ID
where k_ten like "%CNTT%";

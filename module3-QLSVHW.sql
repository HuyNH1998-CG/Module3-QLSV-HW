create database quanlysinhvien2 DEFAULT CHARACTER SET utf8  DEFAULT COLLATE utf8_unicode_ci;
use quanlysinhvien2;
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
value (4, "Ngon ngu"),
(2,"Tài Nguyên"),
(3,"Xây dựng");

insert into tblLop
value (7,"NN01",1),
(5,"TN02",2),
(6,"XD02",3);

insert into tblSinhVien
value (1,"Nguyễn Văn","Tám","2002-09-01",1,8.0),
(2,"Nguyễn Thị","Hà","1990-05-01",2,10.0),
(3,"Nguyễn Tấn","Toàn","1995-12-01",3,5.0);

insert into tblSinhVien
value
(8,"Nguyễn Văn","Tám","2002-09-01",4,9.0),
(9,"Nguyễn Thị","Hà","1990-05-01",5,6.0),
(10,"Nguyễn Tấn","Toàn","1995-12-01",4,7.0)
;

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

-- new
-- Số lượng sinh viên loại giỏi, loại khá, loại trung bình (trong cùng 1 query)
select
count(case when sv_DiemTB > 8.0 then 1 else null end) as "Gioi",
count(case when sv_DiemTB between 6.0 and 8.0 then 1 else null end) as "Kha",
count(case when sv_DiemTB < 6.0 then 1 else null end) as "Trung Binh"
from tblsinhvien;

-- Số lượng sinh viên loại giỏi, khá, trung bình của từng lớp (trong cùng 1 query)
select l_ten, sum(if (sv_diemtb >= 8.0 , 1, 0)) as "gioi",
sum(if(sv_diemtb < 6.0 , 1, 0)) as "trung binh",
sum(if(sv_diemtb between 6.0 and 8.0 , 1, 0)) as "kha"
from tbllop join tblsinhvien
on tblsinhvien.sv_lop = tbllop.l_id
group by tbllop.l_id;

-- Tên lớp, danh sách các sinh viên của lớp sắp xếp theo điểm trung bình giảm dần
select l_ten, sv_ten, sv_diemtb from tbllop
join tblsinhvien on tbllop.l_id = tblsinhvien.sv_lop
order by tbllop.l_id and sv_diemtb asc;

-- Tên lớp, tổng số sinh viên của lớp
select l_ten,
sum(if( tbllop.l_id = tblsinhvien.sv_lop  ,1 ,0)) as "so sinh vien"
from tbllop join tblsinhvien on
tbllop.l_id = tblsinhvien.sv_lop
group by tbllop.l_id;

-- Tên khoa, tổng số sinh viên của khoa
select k_ten,
sum(if( tbllop.l_id = tblsinhvien.sv_lop and tbllop.l_khoa = tblkhoa.k_id ,1 ,0)) as "so sinh vien"
from tbllop join tblsinhvien on
tbllop.l_id = tblsinhvien.sv_lop
join tblkhoa on 
tbllop.l_khoa = tblkhoa.k_id
group by tblkhoa.k_id;

-- Tên khoa, tên lớp, điểm trung bình của sinh viên (chú ý: liệt kê tất cả các khoa và lớp, kể cả khoa và lớp chưa có sinh viên)
select k_ten, l_ten, if(sv_lop = l_id, avg(sv_diemtb), 0) as "diem trung binh" from tblkhoa
left join tbllop
on tbllop.l_khoa = tblkhoa.k_id
left join tblsinhvien
on tblsinhvien.sv_lop = tbllop.l_id
group by tbllop.l_ten;

-- Tên khoa, tên lớp, họ tên, ngày sinh, điểm trung bình của sinh viên có điểm trung bình cao nhất lớp 
select k_ten, l_ten,concat(sv_hodem," ", sv_ten) as "Ho ten",sv_ngaysinh, sv_diemtb from tblsinhvien
join tbllop on l_id = sv_lop
join tblkhoa on k_id = l_khoa
group by sv_lop
having sv_diemtb >= any (select sv_diemtb from tblsinhvien join tbllop on l_id = sv_lop group by l_id);

-- Tên khoa, Họ tên, ngày sinh, điểm trung bình của sinh viên có điểm trung bình cao nhất khoa
select k_ten,concat(sv_hodem," ", sv_ten) as "Ho ten",sv_ngaysinh, sv_diemtb from tblsinhvien
join tbllop on l_id = sv_lop
join tblkhoa on k_id = l_khoa
group by k_id
having sv_diemtb >= any (select sv_diemtb from tblsinhvien join tbllop on l_id = sv_lop group by l_id)
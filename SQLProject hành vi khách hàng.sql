-- Chạy thử dữ liệu làm sạch từ Python
SELECT
	TOP 20 *
FROM dbo.customer;



--C1: Tổng doanh thu từ khách hàng nam và khách hàng nữ
--Tổng doanh thu KH Nam nhiều hơn nữ


SELECT
	gender
	, SUM(purchase_amount) AS Tong_doanh_thu
FROM dbo.customer
GROUP BY
	gender;


-- C2: Doanh thu trung bình cho mỗi khách hàng theo giới tính
-- Doanh thu TB của Nữ nhiều hơn 1$


SELECT
	gender
	, AVG(purchase_amount) AS Doanh_thu_TB
FROM dbo.customer
GROUP BY
	gender;


-- C3: Khách hàng có sử dụng mã giảm giá nhưng vẫn chi tiêu nhiều hơn doanh thu TB trên 1 KH



SELECT
	customer_id
	, discount_applied
	, purchase_amount
FROM dbo.customer
WHERE
	discount_applied = 'Yes'
	AND purchase_amount >= (
							SELECT
								AVG(purchase_amount)
							FROM dbo.customer
							);


--C4: Top 5 sản phẩm có điểm đánh giá tb cao nhất
--Làm tròn đến chữ số thập phân thứ 3



SELECT	
	TOP 5 item_purchased
	, ROUND(
			AVG(review_rating)
			, 3)AS Danh_gia_TB
FROM dbo.customer
GROUP BY
	item_purchased
ORDER BY
	Danh_gia_TB DESC;


--C5: So sánh doanh thu TB của hình thức vận chuyển tiêu chuẩn (Standard) và hình thức vận chuyển nhanh (Express)


SELECT
	shipping_type
	, CAST(
			AVG(purchase_amount*1.0)
			AS DECIMAL( 10, 2)) AS doanh_thu_TB
FROM customer
WHERE
	shipping_type IN ('Standard', 'Express')
GROUP BY
	shipping_type;


--C6: Liệu khách hàng đã đăng ký có tiêu nhiều tiền hơn không ?
-- So sánh chi tiêu của khách hàng đã đk so với chưa đk


SELECT
	subscription_status
	, COUNT(customer_id) AS Tong_khach_hang
	, CAST(
			AVG(purchase_amount*1.0)
			AS DECIMAL (10, 2)
		)AS Doanh_thu_TB
	, SUM(purchase_amount) AS Tong_doanh_thu
FROM customer
GROUP BY
	subscription_status;


--C7: Top 5 sản phẩm có tỷ lệ giảm giá cao


SELECT
	TOP 5 item_purchased
	, CAST(SUM(
			CASE
				WHEN discount_applied = 'Yes' THEN 1
				ELSE 0
			END
			)
	*100.0 / COUNT(customer_id)AS DECIMAL(10, 2)) AS Ty_le_giam_gia
FROM customer
GROUP BY
	item_purchased
ORDER BY
	Ty_le_giam_gia DESC;


--C8: Phân loại khách hàng dựa theo số lần mua hàng của kh
--Sau đó viết truy vấn cho ra sl kh từng phân khúc, sắp xếp giảm dần theo phân khúc lớn nhất

WITH Phân_khúc_KH AS
(
SELECT	
	customer_id
	, previous_purchases
	, CASE 
		WHEN previous_purchases = 1 THEN 'Fresher'
		WHEN previous_purchases <= 10 THEN 'Return'
		ELSE 'Loyal'
	END AS Phân_khúc_KH
FROM customer
)
	SELECT
		Phân_khúc_KH
		, COUNT(*) AS SL_KH
	FROM Phân_khúc_KH
	GROUP BY
		Phân_khúc_KH
	ORDER BY
		SL_KH DESC;



-- C9: Top 3 sản phẩm bán chạy nhất mỗi danh mục hàng hóa


WITH Tong_don_hang AS
(
SELECT
	category
	, item_purchased
	, COUNT(customer_id) AS Tong_don_hang
-- Dùng ROW_NUMBER để đánh số và PARTITION BY để chia các số theo danh mục
	, ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS Xếp_hạng_sản_phẩm
FROM customer
GROUP BY
	category
	, item_purchased
)
SELECT
	Xếp_hạng_sản_phẩm
	, category
	, item_purchased
	, Tong_don_hang
FROM Tong_don_hang
WHERE
	Xếp_hạng_sản_phẩm <= 3;


--C10: Liệu khách hàng mua trên 5 đơn phần nhiều là khách hàng đã đăng ký dịch vụ ?
--Liệu gói đăng ký dịch vụ có hấp dẫn để khách hàng mua hay không dù đã mua hàng nhiều lần ? Có vẻ là ko

SELECT
	subscription_status
	, COUNT(customer_id) AS SL_Khach_hang
FROM customer
WHERE
	previous_purchases > 5
GROUP BY
	subscription_status


--C11: Phân loại doanh thu theo nhóm độ tuổi? Tìm ra nhóm độ tuổi người dùng chi tiêu nhiều nhất



SELECT
	age_group
	, SUM(purchase_amount) AS Tổng_doanh_thu$
FROM customer
GROUP BY
	age_group
ORDER BY
	Tổng_doanh_thu$ DESC


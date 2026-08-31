# customer_behavior_analysis_project
Portfolio: Project sử dụng Python, SQL Server, Power BI để phân tích dữ liệu hành vi khách hàng.

🛒 ShopEasy - Customer Shopping Behavior Analysis(Dự án Phân Tích Hành Vi Mua Sắm Của Khách Hàng)

# Tổng quan
ShopEasy là một doanh nghiệp bán lẻ trực tuyến đang muốn tìm hiểu sâu về hành vi tiêu dùng của khách hàng nhằm tối ưu hóa doanh số, nâng cao mức độ hài lòng và tỷ lệ giữ chân khách hàng.
Dự án này thực hiện quy trình phân tích dữ liệu toàn diện giúp giải quyết bài toán: Làm thế nào để doanh nghiệp tận dụng dữ liệu hành vi mua sắm nhằm xác định xu hướng, tối ưu hóa chiến lược tiếp thị và phát triển sản phẩm?
Dự án bao gồm đầy đủ các bước:
    1.Python: Tiền xử lý, làm sạch và biến đổi dữ liệu thô.
    2.SQL (SQL Server): Truy vấn, phân đoạn khách hàng và trả lời các câu hỏi kinh doanh cốt lõi.
    3.Power BI: Xây dựng bảng điều khiển trực quan tương tác.
    
#. Tập dữ liệu (Dataset)
    1.Tên tệp: customer_shopping_behavior.csv
    2.Quy mô: 3,900 hàng và 18 cột thông tin.
    3.Các trường dữ liệu chính:Customer ID, Age, Gender: Thông tin nhân khẩu học.
    4.Item Purchased, Category, Size, Color, Season: Thông tin sản phẩm & mùa vụ.
    5.Purchase Amount (USD): Giá trị đơn hàng.Review Rating: Điểm đánh giá chất lượng sản phẩm.
    6.Subscription Status, Previous Purchases, Frequency of Purchases: Lịch sử và mức độ gắn kết của khách hàng.
    7.Shipping Type, Discount Applied, Payment Method: Kênh vận chuyển, ưu đãi và phương thức thanh toán.
    
#. Công cụ & Công nghệ
    1.Ngôn ngữ lập trình: Python (pandas, numpy, sqlalchemy, urllib, pyodbc).
    2.Cơ sở dữ liệu: Microsoft SQL Server (sử dụng T-SQL, CTE, Window Functions).
    3.Trực quan hóa: Power BI Desktop (Power Query, DAX, Interactive Visuals).
    4.Môi trường phát triển: Jupyter Notebook, VS Code, SSMS.
    
#. Quy trình thực hiện
.
    Bước 1: Tiền xử lý & Làm sạch dữ liệu (Python)
        1.Xử lý dữ liệu khuyết thiếu: Thay thế 37 giá trị null ở cột Review Rating bằng giá trị trung vị (median) của từng danh mục sản phẩm (Category).
        2.Chuẩn hóa dữ liệu: Chuyển đổi toàn bộ tên cột về dạng lower_snake_case chuẩn hóa (ví dụ: Purchase Amount (USD) $\rightarrow$ purchase_amount).
        3.Kỹ thuật tạo đặc trưng (Feature Engineering):
              - Nhóm độ tuổi (age_group): Phân chia khách hàng thành 4 nhóm (Young, Adult, Middle-age, Senior) bằng hàm pd.qcut().
              - Chuẩn hóa tần suất mua hàng (Tần_Suất_Mua_Hàng): Quy đổi chuỗi tần suất (Weekly, Fortnightly, Monthly,...) sang số ngày tương ứng.
              - Lọc trùng lặp cột: Phát hiện cột promo_code_used có dữ liệu trùng khớp 100% với discount_applied nên tiến hành loại bỏ để tối ưu bộ nhớ.
        4.Nạp dữ liệu vào CSDL: Tạo kết nối an toàn từ Python sang SQL Server qua SQLAlchemy & pyodbc để đẩy dữ liệu sạch vào bảng dbo.customer.
  .
    Bước 2: Truy vấn & Phân tích chuyên sâu (SQL)
    Thực thi 11 truy vấn trên SQL Server bao gồm:
        1.Phân tích doanh thu theo giới tính: So sánh tổng doanh thu và doanh thu trung bình giữa Nam và Nữ.
        2.Hiệu quả chương trình giảm giá: Lọc nhóm khách hàng dùng mã giảm giá nhưng vẫn có mức chi tiêu cao hơn trung bình toàn hệ thống.
        3.Đánh giá sản phẩm: Tìm Top 5 sản phẩm có điểm Review Rating trung bình cao nhất (làm tròn 3 chữ số thập phân).
        4.Phân tích vận chuyển & Hội viên: So sánh doanh thu trung bình của các hình thức giao hàng (Standard vs Express) và tác động của gói đăng ký hội viên (Subscription Status).
        5.Phân đoạn khách hàng (Customer Segmentation): Sử dụng CASE WHEN phân loại khách hàng thành 3 nhóm: Fresher (1 lần mua), Return (2–10 lần), và Loyal (>10 lần).
        6.Xếp hạng sản phẩm bán chạy: Sử dụng CTE kết hợp hàm cửa sổ ROW_NUMBER() OVER (PARTITION BY category ORDER BY ...) để tìm Top 3 sản phẩm bán chạy nhất trong từng danh mục.
        7.Phân tích theo độ tuổi: Xác định nhóm độ tuổi đóng góp doanh thu lớn nhất cho ShopEasy.
        8.Phân tích tác động của Mùa vụ (Seasonality): So sánh tổng số lượng đơn hàng và doanh thu giữa các mùa (Spring, Summer, Fall, Winter). Tìm ra danh mục sản phẩm (Category) nào dẫn            đầu doanh thu trong từng mùa cụ thể (ví dụ: Outerwear có tăng đột biến vào mùa Đông không?).
        9.Đánh giá Phương thức thanh toán (Payment Method Analytics): Tính tỷ lệ phần trăm (%) tần suất sử dụng của các phương thức thanh toán khác nhau (Credit Card, PayPal, Venmo,                 Cash...). Tìm hiểu xem phương thức nào thường được dùng cho các đơn hàng có giá trị lớn (High-value orders).
        10.Phân tích Hiệu suất theo Khu vực (Location/Geography): Xác định Top 5 khu vực/tiểu bang (Location) mang lại tổng doanh thu cao nhất cho ShopEasy. Tính Giá trị đơn hàng trung               bình (AOV - Average Order Value) của các khu vực này để xem khách hàng ở đâu chịu chi nhất.
        11.Tối ưu hóa hàng tồn kho theo Thuộc tính sản phẩm (Size & Color): Thống kê sự kết hợp phổ biến nhất giữa Kích cỡ (Size) và Màu sắc (Color) theo từng giới tính, đặc biệt là trong           danh mục "Clothing" và "Footwear", nhằm giúp bộ phận kho lập kế hoạch nhập hàng chính xác hơn.
.
    Bước 3: Trực quan hóa dữ liệu (Power BI)
        Xây dựng Mô hình dữ liệu (Data Model) và các chỉ số đo lường nâng cao bằng DAX (Total Revenue, Avg Order Value, Repeat Purchase Rate,...).
        Thiết kế Bảng điều khiển trực quan hỗ trợ lọc đa chiều theo Mùa, Độ tuổi, Giới tính và Danh mục sản phẩm.

#. Bảng điều khiển (Dashboard)
      Trang 1 - Báo cáo Tổng quan: Hiển thị các chỉ số KPI cốt lõi (Tổng doanh thu, Số lượng đơn hàng, Điểm đánh giá trung bình).
      Trang 2 - Phân tích Hành vi Khách hàng: Biểu đồ chi tiết về thói quen mua sắm theo nhóm tuổi, kênh thanh toán, phương thức vận chuyển và mức độ trung thành.
      
#. Kết quả & Phát hiện chính
    1.Nhân khẩu học & Doanh thu: Khách hàng Nam chiếm số lượng giao dịch và tổng doanh thu cao hơn (2,652 khách hàng Nam vs 1,248 khách hàng Nữ). Tuy nhiên, mức chi tiêu trung bình trên mỗi khách hàng Nữ lại nhỉnh hơn khoảng $1 USD so với Nam.
    2.Gói đăng ký hội viên (Subscription): Phần lớn khách hàng có hơn 5 lần mua hàng vẫn chưa đăng ký gói hội viên. Điều này cho thấy chính sách đăng ký hiện tại chưa đủ sức hấp dẫn để chuyển đổi khách hàng quen thuộc thành hội viên chính thức.
    3.Danh mục bán chạy: Danh mục Clothing đóng góp tỷ trọng lớn nhất với 1,737 đơn hàng, tiếp theo là Accessories (1,240 đơn).
    4.Phân khúc khách hàng: Khách hàng trung thành (Loyal) chiếm tỷ lệ cao trong hệ thống, đòi hỏi doanh nghiệp cần tập trung vào các chiến lược chăm sóc khách hàng cá nhân hóa.

#. Hướng dẫn chạy dự án (How to Run)
    1. Khởi tạo & Làm sạch dữ liệu (Python)
         1.1 Clone (tải) dự án về máy
          git clone https://github.com/HoangAnhNguyentn16/customer_behavior_analysis_project.git
.
         1.2 Di chuyển vào thư mục dự án vừa tải về
          cd customer_behavior_analysis_project
.
          1.3 Cài đặt các thư viện cần thiết
          pip install pandas sqlalchemy pyodbc jupyter
.
         1.4 Mở và chạy file Jupyter Notebook
        jupyter notebook tên_file_code_của_bạn.ipynb
  
  2. Thiết lập & Thực thi CSDL (SQL Server)
        2.1 Mở SQL Server Management Studio (SSMS).
        2.2 Tạo CSDL mới tên là Hanh_vi_khach_hang.
        2.3 Chạy dòng lệnh Python cuối file ở Bước 1 để tạo và nạp dữ liệu vào bảng dbo.customer.
        2.4 Mở file sql_queries.sql trong thư mục project và thực thi các câu lệnh truy vấn.
  
  3. Xem Dashboard & Slide Báo BáoPower BI:
     Mở file ShopEasy_Dashboard.pbix bằng phần mềm Power BI Desktop.

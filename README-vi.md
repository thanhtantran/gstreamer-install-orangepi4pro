# GStreamer Allwinner Install Script — Hướng dẫn (Tiếng Việt)

Kho lưu trữ này chứa một script Bash để cài đặt các gói liên quan tới GStreamer, các thư viện phát triển GTK4, và các gói Allwinner `arm64` / `aarch64` cục bộ trên hệ Debian/Ubuntu.

Script cũng sẽ sao chép một plugin GStreamer tùy chỉnh `libgstgtk4.so` vào thư mục plugin GStreamer của hệ thống.

---

## Các tập tin trong kho

Hãy đảm bảo các tập tin sau nằm trong cùng thư mục với `install.sh`:

```text
install.sh
libcedarc-dev_2.0.0_arm64.deb
gstreamer1.0-omx-allwinner-config_1.18.3-1.1_arm64.deb
gstreamer1.0-omx-allwinner_1.18.3-1.1_arm64.deb
libgstgtk4.so
README.md
README-vi.md
```

---

## Script này làm gì

Script `install.sh` sẽ thực hiện các bước sau:

1. Cập nhật danh sách gói APT.
2. Cài đặt công cụ biên dịch và các gói phát triển:
   - `build-essential`
   - `cmake`
   - `pkg-config`
   - Thư viện phát triển GTK4
   - Thư viện phát triển GStreamer
3. Cài đặt các gói plugin GStreamer:
   - `gstreamer1.0-tools`
   - `gstreamer1.0-plugins-base`
   - `gstreamer1.0-plugins-good`
   - `gstreamer1.0-plugins-bad`
   - `gstreamer1.0-plugins-ugly`
4. Cài đặt các gói `.deb` Allwinner cục bộ:
   - `libcedarc-dev_2.0.0_arm64.deb`
   - `gstreamer1.0-omx-allwinner-config_1.18.3-1.1_arm64.deb`
   - `gstreamer1.0-omx-allwinner_1.18.3-1.1_arm64.deb`
5. Thử sửa các phụ thuộc bị thiếu nếu `dpkg` gặp lỗi.
6. Sao chép `libgstgtk4.so` tới:

```text
/usr/lib/aarch64-linux-gnu/gstreamer-1.0/
```

---

## Nền tảng hỗ trợ

Script này dành cho:

- Hệ Debian trên kiến trúc ARM64
- Hệ Ubuntu trên kiến trúc ARM64
- Kiến trúc `aarch64` / `arm64`

Ví dụ kiểm tra kiến trúc:

```bash
uname -m
```

Kết quả mong đợi:

```text
aarch64
```

Bạn cũng có thể kiểm tra kiến trúc APT:

```bash
dpkg --print-architecture
```

Kết quả mong đợi:

```text
arm64
```

---

## Yêu cầu

Trước khi chạy script, hãy đảm bảo bạn có:

- Một hệ Debian/Ubuntu trên kiến trúc ARM64
- Kết nối Internet
- Quyền `sudo`
- Các tập tin cần thiết nằm trong thư mục của kho
- Đủ dung lượng ổ đĩa cho việc cài đặt gói

---

## Cách sử dụng

### 1. Clone kho

```bash
git clone https://github.com/thanhtantran/gstreamer-install-orangepi4pro
cd gstreamer-install-orangepi4pro
```

---

### 2. Cho phép thực thi script

```bash
chmod +x install.sh
```

---

### 3. Chạy trình cài đặt

```bash
sudo ./install.sh
```

---

## Sử dụng khi tải ZIP

Nếu bạn tải kho về dưới dạng ZIP từ GitHub:

```bash
unzip gstreamer-install-orangepi4pro.zip
cd gstreamer-install-orangepi4pro
chmod +x install.sh
sudo ./install.sh
```

---

## Kiểm tra sau khi cài đặt

Sau khi cài đặt, kiểm tra GStreamer:

```bash
gst-inspect-1.0 --version
```

Kiểm tra rằng thư viện GTK4 cho GStreamer đã được sao chép:

```bash
ls -l /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstgtk4.so
```

Bạn cũng có thể thử kiểm tra plugin trực tiếp:

```bash
gst-inspect-1.0 /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstgtk4.so
```

---

## Khắc phục sự cố

### Lỗi thiếu tập tin

Nếu bạn thấy lỗi như:

```text
ERROR: missing file: /path/to/libcedarc-dev_2.0.0_arm64.deb
```

Hãy đảm bảo tất cả tập tin cần thiết nằm trong cùng thư mục với `install.sh`.

---

### Lỗi phụ thuộc khi cài `.deb`

Nếu `dpkg` thất bại do thiếu phụ thuộc, script sẽ tự động thử:

```bash
sudo apt-get install -f -y
sudo dpkg --configure -a
```

Nếu vẫn lỗi, đọc kỹ thông báo lỗi của gói. Một trong các gói `.deb` cục bộ có thể cần gói khác chưa được cài.

---

### Cảnh báo sai kiến trúc

Nếu bạn thấy:

```text
WARNING: local packages are for arm64, but this system reports: amd64
```

Bạn đang chạy script trên hệ không phải ARM64. Các gói Allwinner cục bộ dành cho hệ `arm64` / `aarch64`.

---

### GStreamer không tìm thấy plugin

Kiểm tra tập tin plugin tồn tại:

```bash
ls -l /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstgtk4.so
```

Bạn cũng có thể bắt GStreamer quét lại plugin:

```bash
rm -rf ~/.cache/gstreamer-1.0
gst-inspect-1.0
```

---

## Giấy phép

[MIT License](LICENSE)

---

## Từ chối trách nhiệm

Script này được cung cấp "nguyên trạng". Hãy xem xét kỹ script trước khi chạy, đặc biệt nếu bạn dùng trên hệ sản xuất.

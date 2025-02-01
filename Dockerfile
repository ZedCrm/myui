# مرحله ساخت برنامه Angular
FROM node:18 AS build
WORKDIR /app

# کپی فایل‌های مربوط به وابستگی‌ها
COPY package*.json ./

# نصب پکیج‌ها با استفاده از --legacy-peer-deps
RUN npm install --legacy-peer-deps

# کپی تمام فایل‌های پروژه به داخل کانتینر
COPY . .

# ساخت برنامه با استفاده از ng build در حالت production
RUN npx ng build --configuration production

# مرحله نهایی: سرویس‌دهی با Nginx
FROM nginx:latest

# کپی خروجی build از مرحله قبل به دایرکتوری پیش‌فرض Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# کپی فایل تنظیمات Nginx (اطمینان حاصل کنید که فایل nginx.conf در مسیر پروژه وجود دارد)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# باز کردن پورت 80
EXPOSE 80

# اجرای Nginx در حالت foreground
CMD ["nginx", "-g", "daemon off;"]

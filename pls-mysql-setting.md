-- mysql cli 접속
mysql -u root -p

-- 사용자 권한 부여 (외부 접근 허용)
GRANT ALL PRIVILEGES ON _._ TO 'root'@'%' WITH GRANT OPTION;

-- 사용자 비밀번호 변경
ALTER USER 'root'@'%' IDENTIFIED BY '1q2w3e4r!';

-- 권한 변경 사항 적용
FLUSH PRIVILEGES;

-- payment_token 컬럼을 NULL 허용으로 변경
ALTER TABLE orders 
MODIFY COLUMN payment_token VARCHAR(255) NULL;

-- created_at 컬럼 추가 (이미 있으면 무시)
ALTER TABLE orders 
ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- 확인 쿼리
DESC orders;

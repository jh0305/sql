사용자 생성 및 테이블 생성
user_create.sql
scott.sql
base_table.sql
users.sql

SELECT 실습
문법
SELECT *|


SELECT *
FROM prod;

SELECT prod_id, prod_name
FROM prod;

SELECT (실습 select1)
1. lprod 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요
SELECT *
FROM lprod;

2. buyer 테이블에서 buyer_id, buyer_name 컬럼만 조회하는 쿼리를 작성하세요
SELECT buyer_id, buyer_name
FROM buyer;

3. cart 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요
SELECT *
FROM cart;

4.member 테이블에서 mem_id, mem_pass, mem_name 컬럼만 조회하는 쿼리를 작성하세요
SELECT mem_id, mem_pass, mem_name
FROM member;

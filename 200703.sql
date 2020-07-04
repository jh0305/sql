oracle

SELECT lprod_gu, lprod_nm, prod_id, prod_name 
FROM lprod l, prod p
WHERE p.prod_lgu = l.lprod_gu; 

ansi-SQL 두 테이블의 연결 컬럼명이 다르기 때문에 NATURAL JOIN, JOIN with USING은 사용이 불가

SELECT lprod_gu, lprod_nm, prod_id, prod_name 
FROM lprod l JOIN prod p ON (p.prod_lgu = l.lprod_gu); 

실습 join2
erd 다이어그램을 참고하여 buyer, prod 테이블을 조인하여 buyer별 담당하는 제품 정보를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요.
SELECT *
FROM buyer;

SELECT *
FROM prod;

oracle
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM prod, buyer -- 테이블 순서에 따른 결과에 영향을 미치지 않음.
WHERE prod.prod_buyer = buyer.buyer_id;

실습 join3
erd 다이어그램을 참고하여 member, cart, prod 테이블을 조인하여 회원별 장바구니에 담은 제품 정보를 다음과 같은 결과가 나오는 쿼리를 작성해보세요.
oracle
select mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member, cart, prod
WHERE member.mem_id = cart.cart_member
    AND cart.cart_prod = prod.prod_id;

oracle(IN-LINE)
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM(SELECT *
FROM member, cart
WHERE member.mem_id = cart.cart_member) e, prod
WHERE e.cart_prod = prod.prod_id

ansi-SQL
select mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member JOIN cart ON(member.mem_id = cart.cart_member) JOIN prod ON (cart.cart_prod = prod.prod_id);

ansi-SQL(IN-LINE)
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM(SELECT *
     FROM member JOIN cart ON (member.mem_id = cart.cart_member)) e JOIN prod ON(e.cart_prod = prod.prod_id);
     
*IN_LINE 남발하지 말것. 

CUSTOMER : 고객
PRODUCT : 제품
CYCLE : 고객 제품 애음 주기

SELECT *
FROM cycle;

실습 join4
erd 다이어그램을 참고하여 customer, cycle 테이블을 조인하여 고객별 애음 제품, 애음요일, 
개수를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요.
(고객명이 brown, sally인 고객만 조회) (*정렬과 관계없이 값이 맞으면 정답)
SELECT customer.cid, cnm, pid, day, cnt
SELECT customer.*, cnm, pid, day, cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid
        AND customer.cnm IN ('brown', 'sally');

실습 join5
erd 다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여 고객별 애음 제품, 애음요일, 
개수, 제품명을 다음과 같은 결과가 나오도록 쿼리를 작성해보세요.
(고객명이 brown, sally인 고객만 조회) (*정렬과 관계없이 값이 맞으면 정답)
SELECT customer.*, cnm, product.pid, pnm, day, cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid 
        AND cycle.pid = product.pid
        AND customer.cnm IN ('brown', 'sally');

실습 join6
erd 다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여 애음요일과 상관없이 
고객별 애음 제품별, 개수의합, 제품명을 다음과 같은 결과가 나오도록 쿼리를 작성해보세요.
(*정렬과 관계없이 값이 맞으면 정답)
SELECT customer.*, product.pid, pnm, SUM(cnt)
FROM customer, cycle, product
WHERE customer.cid = cycle.cid AND cycle.pid = product.pid
GROUP BY customer.cid, customer.cnm, product.pid, pnm; -- select 컬럼 나타내기
15조인 ==> 6 GROUP

(SELECT cid, pid, SUM(cnt)
FROM cycle
GROUP BY cid, pid) cycle, customer, product;


실습 join7
erd 다이어그램을 참고하여 cycle, product 테이블을 조인하여 제품별, 개수의합과 제품명을 
다음과 같은 결과가 나오도록 쿼리를 작성해보세요.
(*정렬과 관계없이 값이 맞으면 정답)
SELECT cycle.pid, pnm, SUM(cnt)
FROM product, cycle
WHERE product.cid = cycle.cid
GROUP BY cycle.pid, pnm;
        
실습 join 8~13 풀기 hr 시트

조인 성공 여부로 데이터 조회를 결정하는 구분방법
INNER JOIN : 조인에 성공하는 데이터만 조회하는 조인 방법
OUTER JOIN : 조인에 실패 하더라도, 개발자가 지정한 기준이 되는 데이터 테이블의 데이터는 나오도록 하는 조인
OUTER <==> INNER JOIN

복습 - 사원의 관리자 이름을 알고 싶은 상황
    조회 컬럼 : 사원의 사번, 사원의 이름, 사원의 관리자의 사번, 사원의 관리자의 이름

동일한 테이블끼리 조인 되었기 때문에 : SELF-JOIN
조인 조건을 만족하는 데이터만 조회되었기 때문에 : INNER-JOIN
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

KING의 경우 PRESIDENT이기 때문에 mgr 컬럼의 값이 NULL ==> 조인에 실패
==> KING의 데이터는 조회되지 않음 (총 14건 데이터중 13건의 데이터만 조인 성공)

OUTER 조인을 이용하여 조인 테이블 중 기준이 되는 테이블을 선택하면 조인에 실패하더라도 기준 테이블의 데이터는 조회되도록 할 수 있다.
LEFT / RIGHT OUTER
ANSI-SQL
테이블1 JOIN 테이블2 ON (....)
테이블1 LEFT OUTER JOIN 테이블2 ON (....)
위 쿼리는 아래와 동일
테이블2 RIGHT OUTER JOIN 테이블1 ON (....)

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);

이번 발표는 문제풀이 위주
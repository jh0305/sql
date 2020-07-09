OUTER JOIN < == > INNER JOIN 
INNER JOIN : 조인 조건을 만족하는 (조인에 성곡하는) 데이터만 조회
OUTER JOIN : 조인 조건을 만족하지 않더라도 (조인에 실패하더라도) 기준이 되는 테이블 쪽의 데이터(컬럼)은 조회가 되도록 하는 조인 방식

* OUTER JOIN  
LEFT OUTER JOIN : 조인 키워드의 왼쪽에 위치하는 테이블을 기준삼아 OUTER JOIN 시행
RIGHT OUTER JOIN : 조인 키워드의 오른쪽에 위치하는 테이블을 기준삼아 OUTER JOIN 시행
FULL OUTER JOIN : LEFT OUTER + RIGHT OUTER - 중복되는것 제외 (사용하는 경우가 드물다)

ANSI-SQL 
FROM 테이블1 LEFT OUTER JOIN 테이블2 ON (조인 조건)

ORACLE-SQL : 데이터가 없는데 나와야하는 테이블의 컬럼
FROM 테이블1, 테이블2
WHERE 테이블1.컬럼 = 테이블2.컬럼 (+)

ANSI-SQL OUTER
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);

ORACLE-SQL OUTER
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

OUTER JOIN시 조인 조건 (ON 절에 기술)과 일반 조건(WHERE 절에 기술)적용시 주의 사항
: OUTER JOIN을 사용하는데 WHERE 절에 별도의 다른 조건을 기술할 경우 원하는 결과가 안나올 수 있다
  ==> OUTER JOIN의 결과가 무시
  
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno AND m.deptno = 10);

ORACLE-SQL
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+) 
      AND m.deptno (+) = 10;


조인 조건을 WHERE 절로 변경한 경우
위의 쿼리는 OUTER JOIN을 적용하지 않은 아래 쿼리와 동일한 결과를 나타낸다.
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
WHERE  m.deptno = 10;

WHERE 절에 (+) 하나라도 빠지면 INNER JOIN 으로 결과가 나온다.
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+) 
      AND m.deptno = 10;

RIGHT OUTER JOIN : 기준 테이블이 오른쪽
(아래의 결과는 14부터는 매니저가 아니다 평사원 임.)
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno);

FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno); : 14건
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno); : 21건

FULL OUTER JOIN : LEFT OUTER + RIGHT OUTER - 중복제거

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);

ORACLE SQL에서는 FULL OUTER 문법을 제공하지 않음
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e,emp m
WHERE e.mgr(+) = m.empno(+);

내가 데이터를 조회한것이 맞는지 확인할 때 사용
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
UNION
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno)
MINUS --차집합
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);


SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
UNION
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno)
INTERSECT --교집합
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);

과제 outerjoin 1~5
outerjoin1 
buyprod 테이블에 구매일자가 2005년 1월 25일 데이터는 3품목 밖에 없다. 모든 품목이 나올 수 있도록 쿼리를 작성 해보세요.
select buy_date, buyprod.buy_prod, prod_id, prod_name, buy_qty 
FROM prod, buyprod
WHERE prod.prod_id = buyprod.buy_prod(+)
    AND buy_date(+) = '2005/01/25';
    
outerjoin2
outerjoin1에서 작업을 시작하세요. buy_date 컬럼이 null인 항목이 안나오도록 다음처럼 데이터를 채워지도록 쿼리를 작성하세요.
select NVL(buy_date,'2005/01/25'), buyprod.buy_prod, prod_id, prod_name, buy_qty 
FROM prod, buyprod
WHERE prod.prod_id = buyprod.buy_prod(+)
    AND buy_date(+) = '2005/01/25';
    
outerjoin3
outerjoin2에서 작업을 시작하세요. buy_qty 컬럼이 null일 경우 0으로 보이도록 쿼리를 수정하세요.
SELECT NVL(buy_date,'2005/01/25'), buyprod.buy_prod, prod_id, prod_name, NVL(buy_qty,0) 
FROM prod, buyprod
WHERE prod.prod_id = buyprod.buy_prod(+)
    AND buy_date(+) = '2005/01/25';
    
outerjoin4
cycle, product 테이블을 이용하여 고객이 애음하는 제품 명칭을 표현하고, 애음하지 않는 제품도 다음과 같이 조회되도록 쿼리를 작성하세요.
(고객은 cid = 1인 고객만 나오도록 제한, null처리)
SELECT cycle.pid, pnm, cid, day, cnt
FROM cycle, product
WHERE cycle.pid = product.pid
    AND cid = 1;

SELECT cycle.pid, pnm, cycle.cid, day, cnt
FROM cycle, product
WHERE cycle.pid = product.pid(+)
    AND cid (+) = 1;

SELECT cycle.pid, pnm, cycle.cid, day, cnt
FROM cycle LEFT OUTER JOIN product ON (cycle.pid = product.pid AND cid = 1);

SELECT *
FROM cycle, product;

SELECT *
FROM buyprod;

지금까지의 과정 중 중요한 내용(잘 이해할 필요!)
WHERE : 행을 제한
JOIN : 
GROUP FUNCTION : 

시도 : 서울특별시, 충청남도
시군구 :강남구, 청주시
스토어 구분


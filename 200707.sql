복습
시도, 시군구별, 햄버거 도시발전지수 ==> (kfc + 버거킹 + 맥도날드) / 롯데리아

한행에 다음과 같이 컬림이 구성되면 공식을 쉽게 적용할 수 있다.
시도, 시군구, kfc개수, 버거킹 개수, 맥도날드 개수, 롯데리아 개수

주어진 것 : 하나하나의 주소
1. 시도, 시군구, 프렌차이즈 별로 GROUP BY * 4

1.1 시도, 시군구, kfc개수
1.2 시도, 시군구, 버거킹개수
1.3 시도, 시군구, 맥도날드개수
1.4 시도, 시군구, 롯데리아 개수

1.1~1.4 4개의 데이터셋을 이용해서 컬럼 확장이 가능 == join
시도, 시군구 같은 데이터끼리 조인

2. 시도, 시군구, 프렌차이즈 별로 GROUP BY * 2
2.1 시도, 시군구, 분자 프렌차이즈 합 개수
2.2 시도, 시군구, 분모 프렌차이즈(롯데리아) 합 개수
2.1~2.2 2개의 데이터 셋을 이용해서 컬럼 확장 ==> join
    시도, 시군구 같은 데이터끼리 조인
    
3. 모든 프렌차이즈를 한번만 읽고서 처리하는 방법
 3.1 fastfood 테이블의 한행은 하나의 프렌차이즈에 속함
 3.2 가상의 컬럼을 4개를 생성
    3.2.1 해당 row가 kfc이면 1
    3.2.2 해당 row가 맥도날드이면 1
    3.2.3 해당 row가 버거킹이면 1
    3.2.4 해당 row가 롯데리아이면 1
    3.2 과정에서 생성된 컬럼 4개중에 값이 존재하는 컬럼은 하나만 존재함
        (하나의 행은 하나의 프렌차이즈의 주소를 나타내는 정보)
        
3.3 시도, 시군구 별로 3.2과정에서 생성한 컬럼을 더하면 우리가 구하고자 하는 
    프렌차이즈별 건수가 된다.
    
SELECT sido, sigungu,
        ROUND((NVL(SUM(DECODE(storecategory, 'KFC', 1)),0)+  NVL(SUM(DECODE(storecategory, 'BURGER KING', 1)),0)+ 
        NVL(SUM(DECODE(storecategory, 'MACDONALD', 1)),0))/ NVL(SUM(DECODE(storecategory, 'LOTTERIA', 1)),1),2) score    
FROM burgerstore
WHERE storecategory IN ('MACDONALD' ,'KFC' ,'BURGER KING', 'LOTTERIA')
GROUP BY sido, sigungu
ORDER BY score DESC;

SELECT storecategory
FROM burgerstore
GROUP BY storecategory;

(SELECT ROWNUM, sido, sigungu, score
FROM
(SELECT sido, sigungu,
        ROUND((NVL(SUM(DECODE(storecategory, 'KFC', 1)),0)+  NVL(SUM(DECODE(storecategory, 'BURGER KING', 1)),0)+ 
        NVL(SUM(DECODE(storecategory, 'MACDONALD', 1)),0))/ NVL(SUM(DECODE(storecategory, 'LOTTERIA', 1)),1),2) score    
FROM burgerstore
WHERE storecategory IN ('MACDONALD' ,'KFC' ,'BURGER KING', 'LOTTERIA')
GROUP BY sido, sigungu
ORDER BY score DESC)) burger,

ORDER BY one DESC;
순위, 햄버거 발전지수, 시도, 시군구, 햄버거 발전지수, 
근로소득순위, 근로소득 시도, 근로소득 시군구, 1인당 근로소득액

같은 순위끼리 하나의 행에 데이터가 보여지도록

1, 서울, 강남구, 6.4, 1, 울산, 동구, 80
2. 강원, 춘천시, 6, 2, 서울, 강낭구, 70
SELECT burger.*, tax.*
FROM
(SELECT ROWNUM rn, sido, sigungu, score
FROM
(SELECT sido, sigungu,
        ROUND((NVL(SUM(DECODE(storecategory, 'KFC', 1)),0)+  NVL(SUM(DECODE(storecategory, 'BURGER KING', 1)),0)+ 
        NVL(SUM(DECODE(storecategory, 'MACDONALD', 1)),0))/ NVL(SUM(DECODE(storecategory, 'LOTTERIA', 1)),1),2) score    
FROM burgerstore
WHERE storecategory IN ('MACDONALD' ,'KFC' ,'BURGER KING', 'LOTTERIA')
GROUP BY sido, sigungu
ORDER BY score DESC)) burger,
(SELECT ROWNUM rn, sido, sigungu, tax
FROM
    (SELECT sido, sigungu, ROUND((sal/people), 2) tax
     FROM tax
     ORDER BY tax DESC)) tax
WHERE burger.rn(+) = tax.rn
ORDER BY tax.rn;

cross join : 테이블간 조인 조건을 기술하지 않는 형태로 두 테이블의 행간 모든 가능한 조합으로 조인이 되는 형태
크로스 조인의 조회 결과를 필요로 하는 메뉴는 거의 없음
*SQL의 중간 단계에서 필요한 경우는 존재

emp : 14
dept :4
결과 : 56
원래 하려던 것 : emp에 있는 부서번호를 이용하여 dept쪽에 있는 dname, loc 컬럼을 가져오는 것
SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e, dept d;

SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e CROSS JOIN dept d;

SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e JOIN dept d ON (1=1);
--WHERE e.deptno = d.deptno;

crossjoin 1
customer, product 테이블을 이용하여 고객이 애음 가능한 모든 제품의 정보를 결합하여 다음과 같이 조회되도록 쿼리를 작성하세요.
SELECT *
FROM customer, product;

SELECT *
FROM customer CROSS JOIN product;

SELECT *
FROM customer JOIN  product ON (1=1);


SUBQUERY : SQL 내부에서 사용된 SQL(Main 쿼리에서 사용된 쿼리);
사용위치 따른 분류
1. SELECT 절 : scalar(단일의) subquery
2. FROM 절 : IN-LINE-VIEW
3. WHERE 절 : subquery

반화하는 행, 컬럼 수에 따라
1. 단일행, 단일 컬럼
2. 단일행, 복수 컬럼
3. 다중행, 단일 컬럼
4. 다중행, 복수 컬럼

서브쿼리에서 메인쿼리의 컬럼을 사용유무에 따른 분류
1. 서브쿼리에서 메인쿼리의 컬럼 사용 : correlated subquery ==> 상호 연관 서브쿼리
                        ==> 서브쿼리 단독으로 실행하는 것이 불가능
2. 서브쿼리에서 메인쿼리의 컬럼 미사용 : non correlated subquery ==> 비상호 연관 서브쿼리
                        ==> 서브쿼리 단독으로 실행하는 것이 가능

SMITH 사원이 속한 부서에 속하는 사원들은 누가 있을까?

2번의 쿼리가 필요
1. SMITH가 속한 부서의 번호를 확인하는 쿼리
2. 1번에서 확인한 부서번호로 해당 부서에 속하는 사원들을 조회하는 쿼리

1.
SELECT *
FROM emp
WHERE ename = 'SMITH';

2.
SELECT *
FROM emp
WHERE deptno = 20;

SMITH가 현재 상황에서 속한 부서는 20번인데
나중에 30번 부서로 부서전배가 이뤄지면
2번에서 작성한 쿼리가 수정이 되어야한다.
WHERE deptno = 20 ==> WHERE deptno = 30

우리가 원하는 것은 고정된 부서번호로 사원 정보를 조회하는것이 아니라
SMITH가 속한 부서를 통해 데이터를 조회 ==> SMITH가 속한 부서가 바뀌더라도 쿼리를 수정하지 않도록 하는 것

위에서 작성한 쿼리를 하나로 합칠 수 있음.
==> SMITH의 부서번호가 변경 되더라도 우리가 원하는 데이터 셋을 미리 수정 없이 조회할 수 있다. ==> 코드 변경이 필요 없다 ==> 유지보수가 편하다.
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH'); --괄호값은 20이다.  

1. 스칼라 서브쿼리 : SELECT 절에서 사용된 서브쿼리
*제약사항 : 반드시 서브쿼리가 하나의 행, 하나의 컬럼을 반환 해야된다.
SELECT empno, ename, (SELECT deptno, dname FROM dept WHERE deptno = 10)
FROM emp;

스칼라 서브쿼리가 다중행 복수컬럼을 리턴하는 경우 (X)
SELECT empno, ename, (SELECT deptno, dname FROM dept)
FROM emp;

스칼라 서브쿼리가 단일행 복수컬럼을 리턴하는 경우(X)
SELECT empno, ename, (SELECT deptno, dname FROM dept WHERE deptno = 10)
FROM emp;

스칼라 서브쿼리가 단일행, 단일컬럼을 리턴하는 경우(O)
SELECT empno, ename,
      (SELECT deptno FROM dept WHERE deptno = 10) deptno,
      (SELECT dname FROM dept WHERE deptno = 10) dname
FROM emp;

메인쿼리의 컬럼을 사용하는 스칼라 서브쿼리
SELECT empno, ename, deptno,
      (SELECT dname FROM dept WHERE deptno = emp.deptno) dname
FROM emp;

SELECT empno, ename, deptno, dname
FROM emp;

IN-LINE VIEW : 그동안 많이 사용

SUBQUERY : WHERE절에서 사용 된 것
SMITH가 속한 부서에 속하는 사원들 조회
WHERE 절에서 서브 쿼리 사용시 주의점
연산자와, 서브쿼리의 반환 행수 주의
 = 연산자 사용시 서브쿼리에서 여러개 행(값)을 리턴하면 논리적 맞지가 않다.
IN 연산자를 사용시 서브쿼리에서 리턴하는 여러개 행(값)과 비교가 가능 


SMITH 20, ALLEN 30 
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename IN ('SMITH', 'ALLEN'));
WHERE doptno IN (20, 30);

실습 sub1
1. 평균 급여 구하기
SELECT AVG(sal)
FROM emp;

SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
                    FROM emp);
                    
실습 sub2
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
                    FROM emp);

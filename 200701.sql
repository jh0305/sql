DECODE : 조건에 따라 반환 값이 달라지는 함수
        ==> 비교, JAVA, (if), SQL - CASE와 비슷
        단 비교연산이 (=)만 가능
        CASE의 WHERE절에 기술할 수 있는 코드는 참 거짓 판단할 수 있는 코드면 가능
        ex : sal > 1000
        이것과 다르게 DECODE 함수에서는 SAL = 1000, SAL = 2000
        
DECODE는 가변인자(인자의 갯수가 정해지지 않음, 상황에 따라 늘어날 수도 있다.)를 갖는 함수
문법 : DECODE(기준값[col|expression], 
              비교값1, 반환값1,
              비교값2, 반환값2,
              비교값3, 반환값4,
              옵션[기준값이 비교값중에 일치하는 값이 없을 때 기본적으로 반환할 값]) *옵션은 있을수도 없을수도 있다.
              
==> JAVA
if (기준값 == 비교값1)
    반환값1을 반환해준다.
else if (기준값 === 비교값2)
    반환값2을 반환해준다
else if (기준값 === 비교값3)
    반환값3을 반환해준다
else 
    마지막 인자가 있을경우 마지막 인자를 반환하고
    마지막 인자가 없을경우 null을 반환
    
SELECT empno, ename, 
        CASE
            WHEN deptno = '10' THEN 'ACCOUTING'
            WHEN deptno = '20' THEN 'RESEARCH'
            WHEN deptno = '30' THEN 'SALES'
            WHEN deptno = '40' THEN 'OPERATIONS'
            ELSE 'DDIT'
        END dname
FROM emp;   

어제 작성한 위의 SQL을 DECODE

SELECT empno, ename, deptno ,DECODE ( deptno, 
                                     10, 'ACCOUNTING', 
                                     20, 'RESEARCH',
                                     30, 'SALES',
                                     40, 'OPERTIONS',
                                     'DDIT') dname

FROM emp;

SELECT ename, job, sal, DECODE ( job,
                                'SALESMAN', sal * 1.05,
                                'MANAGER', sal * 1.10,
                                'PRESIDENT', sal * 1.20,
                                sal * 1) bounus
FROM emp;

위의 문제 처럼 job에 따라 sal을 인상을 한다
단 추가조건으로 job이 MANAGER이면서 소속부서가(deptno)가 30(SALES)이면 sal* 1.5

SELECT *
FROM emp;

SELECT ename, job, sal, deptno,
       CASE          
            WHEN job = 'MANAGER'  and deptno = 30 THEN sal * 1.5
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER'  THEN sal * 1.1
            WHEN job = 'PRESIDENT' THEN sal * 1.20
            ELSE sal
       END inc_sal
FROM emp;
(순서가 중요 if문은 만족하면 빠져나오기 때문에 순서를 만족해야한다.)
SELECT ename, job, sal, deptno,
       CASE          
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER'  THEN
                                    CASE   
                                         WHEN deptno = 30  THEN sal * 1.5
                                         ELSE sal * 1.1
                                         END
            WHEN job = 'PRESIDENT' THEN sal * 1.20
            ELSE sal
       END inc_sal
FROM emp;

위의 문제를 DECODE로 변경
SELECT ename, job, sal, DECODE ( job,
                                'SALESMAN', sal * 1.05,
                                'PRESIDENT', sal * 1.20,
                                'MANAGER', DECODE(deptno, 30, sal * 1.5,
                                                                sal * 1.1),
                                sal * 1) bounus
FROM emp;

실습 cond2
emp 테이블을 이용하여hiredate에 따라 올해 건강보험 검진 대상자인지 조회하는 쿼리를 작성하세요.
(생년을 기준으로 하나 여기서는 입사년도를 기준으로 한다)
Tip mod함수 이용
SELECT empno, ename, hiredate,
                    CASE
                    WHEN hiredate
FROM emp;

SELECT empno, ename, hiredate,
        DECODE(MOD(TO_CHAR(hiredate, 'YYYY'),2),
                            MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) , '건강검진 대상자', '건강검진 비대상자')CONTATCT_TO_DOCTOR
FROM emp;
              
cond3 
SELECT userid, usernm, reg_dt,
        DECODE(MOD(TO_CHAR(reg_dt, 'YYYY'),2),
                MOD(TO_CHAR(SYSDATE, 'YYYY'), 2), '건강검진 대상자', '건강검진 비대상자') CONTATCT_TO_DOCTOR
FROM users;


DELETE emp
WHERE empno = 9999;
COMMIT;

그룹함수 : 여러개의 행을 입력으로 받아서 하나의 행으로 결과를 리턴하는 함수
SUM : 합계 
COUNT : 행의 수
AVG : 평균
MAX : 그룹에서 가장 큰 값
MIN : 그룹에서 가장 작은 값

사용방법
SELECT 행들을 묶을 기준1, 행들을 묶을 기준2, 그룹함수 ==> SELECT 구절에 올 수 있음
FROM 테이블 명
(WHERE)
GROUP BY 행들을 묶을 기준1, 행들을 묶을 기준2

부서번호별 sal 컬럼의 합
==> 부서번호가 같은 행들은 하나의 행으로 만든다
SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno;

2. 부서번호별 가장 큰 급여를 받는사람 급여액수
3. 부서번호별 가장 작은 급여를 받는사람 급여액수
4. 부서번호별 평균 급여 급여액수
5. 부서번호별 급여가 존재하는 사람의 수(sal 컬럼이 null이 아닌 행의 수)
                                    * : 그 그룹의 행수
SELECT deptno, SUM(sal),MAX(sal), MIN(sal), ROUND(AVG(sal),2), COUNT(sal), COUNT(*), COUNT(comm)
FROM emp
GROUP BY deptno;

그룹 함수의 특징 : 
1. null값을 무시
30번 부서의 사원 6명중 2명은 comm값이 NULL
SELECT deptno, SUM(comm)
FROM emp
GROUP BY deptno;

2. GROUP BY를 적용 여러행을 하나의 행으로 묶게 되면 SELECT 절에 기술 할 수 있는 컬림이 제한됨
  ==> SELECT 절에 기술되는 일반 컬럼들은 (그룹 함수를 적용하지 않은) 반드시 GROUP BY 절에 기술 되어야 한다.
  * 단 그룹핑에 영향을 주지 않는 고정된 상수, 함수는 기술하는 것이 가능하다.
SELECT deptno, ename, SUM(sal)
FROM emp
GROUP BY deptno;

SELECT deptno, 10, SYSDATE, SUM(sal)
FROM emp
GROUP BY deptno;
그룹함수 이해하기 힘들다 ==> 엑셀에 데이터를 그려보자.

3. 일반 함수를 WHREW 절에 사용하는게 가능
   WHERE UPPER('smith') = 'SMITH';
   그룹함수의 경우 WHERE 절에서 사용하는게 불가능
   하지만 HAVING 절에 기술하여 동일한 결과를 나타낼 수 있다.
SUM(sal) 값이 9000보다 큰 행들만 조회하고 싶은 경우
SELECT deptno, SUM(sal)
FROM emp
WHERE SUM(sal) > 9000
GROUP BY deptno;

SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno
HAVING SUM(sal) > 9000;

위의 쿼리를 HAVIGN절 없이 SQL 작성
SELECT *
FROM(SELECT deptno, SUM(sal) sum_sal
    FROM emp
    GROUP BY deptno) sum_sal
WHERE sum_sal > 9000;

SELECT 쿼리 문법 총 정리
SELECT 
FROM
WHERE
GROUP BY
HAVING
ORDER BY

GROUP BY 절에 행을 그룹핑할 기준을 작성
EX : 부서번호별로 그룹을 만들경우
    GROUP BY deptno

전체행을 기준으로 그룹핑을 하려면 GROUP BY 절에 어떤 컬럼을 기술해야 할까?
emp테이블에 등록된 14명의 사원 전체의 급여 합계를 구하려면?? ==> 결과는 1개의 행
==> GROUP BY 절을 기술하지 않는다.
SELECT SUM(sal)
FROM emp;

GROUP BY 절에 기술한 컬럼을 SELECT 절에 기술하지 않은 경우??
SELECT SUM(sal)
FROM emp
GROUP BY deptno;
==> SELECT deptno만 보여주지 않을 뿐 결과는 나옴

그룹함수의 제한사항
부서번호별 가장 높은 급여를 받는 사람의 급여액
그래서 그 사람이 누구?? (서브쿼리, 분석함수)
SELECT deptno, MAX(sal)
FROM emp
GROUP BY deptno;


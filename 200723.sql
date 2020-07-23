계층쿼리
    테이블(데이터셋)의 행과 행사이의 연관관계를 추적하는 쿼리
    ex : emp테이블 해당사원의 mgr컬럼을 통해 상급자를 추적 가능
        1. 상급자 직원을 다른 테이블로 관리하지 않음
            1-1. 상급자 구조가 계층이 변경이 되도 테이블의 구조는 변경 할 필요가 없다
        
        2. join : 테이블 간 연결
                    FROM emp, dept
                    WHERE emp.deptno = dept.deptno
            계층쿼리 : 행과 행사이의 연결 (자기 참조)
                    PRIOR : 현재 읽고 있는 행을 지칭
                    X : 앞으로 읽을 행
                    
실습 h_4
select * 
FROM h_sum;
DESC h_sum;

SELECT LPAD(' ',(LEVEL -1)*4)|| s_id AS S_ID, VALUE
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;

create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XX회사', null, 1);
insert into no_emp values('정보시스템부', 'XX회사', 2);
insert into no_emp values('개발1팀', '정보시스템부', 5);
insert into no_emp values('개발2팀', '정보시스템부', 10);
insert into no_emp values('정보기획부', 'XX회사', 3);
insert into no_emp values('기획팀', '정보기획부', 7);
insert into no_emp values('기획파트', '기획팀', 4);
insert into no_emp values('디자인부', 'XX회사', 1);
insert into no_emp values('디자인팀', '디자인부', 7);

commit;

SELECT 
FROM no_emp;

실습 h_5
SELECT LPAD(' ', (LEVEL-1) * 4) || org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;

가지치기 (pruning branch)
SELECT 쿼리의 실행순서 : FROM -> WHERE -> SELECT -> ORDER BY 
계층 쿼리의 SELECT쿼리 실행 순서 : FROM -> START WITH, CONNECT BY -> WHERE 

계층 쿼리에서 조회할 행의 조건을 기술 할 수 있는 부분이 두군데 존재
1. CONNECT BY : 다음 행으로 연결하지, 말지를 결정
2. WHERE : START WIHT CONNECT BY에 의해 조화된 행을 대상으 적용

SELECT LPAD(' ' , (level-1) *4) || deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd AND  deptnm !='정보기획부';

SELECT LPAD(' ' , (level-1) *4) || deptnm
FROM dept_h
AND  deptnm !='정보기획부'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd ;

계층쿼리에서 가용할 수 있늩 특정함수
CONNECT _BY_ROOT(col) : 최ㅎ상위 행 ca1값
SYS_CONNECT_BT_PATH(col, 구분자 ) : 계층의 순회경료를 표현
CONNECT_BY_ISLEAF : 해당 행이 LEAF NODE(1) 인지 아닌지(0)를 반환

SELECT deptcd, p_deptcd, LPAD(' ' , (LEVEL -1) * 4)|| deptnm,
       CONNECT_BY_ROOT(deptnm),
       LTRIM(SYS_CONNECT_BY_PATH(deptnm, '-'), '-')
       CONNECT_BY_ISLEAF
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, '첫번째 글입니다');
insert into board_test values (2, null, '두번째 글입니다');
insert into board_test values (3, 2, '세번째 글은 두번째 글의 답글입니다');
insert into board_test values (4, null, '네번째 글입니다');
insert into board_test values (5, 4, '다섯번째 글은 네번째 글의 답글입니다');
insert into board_test values (6, 5, '여섯번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (7, 6, '일곱번째 글은 여섯번째 글의 답글입니다');
insert into board_test values (8, 5, '여덜번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (9, 1, '아홉번째 글은 첫번째 글의 답글입니다');
insert into board_test values (10, 4, '열번째 글은 네번째 글의 답글입니다');
insert into board_test values (11, 10, '열한번째 글은 열번째 글의 답글입니다');
commit;

SELECT *
FROM board_test;

SELECT seq, gn, CONNECT_BY_ROOT(seq), LPAD(' ', (LEVEL-1) * 4) || TITLE as title 
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq;

SELECT *
FROM
(SELECT seq, gn, CONNECT_BY_ROOT(seq) s_gn, LPAD(' ', (LEVEL-1) * 4) || TITLE as title 
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq)
ORDER BY s_gn DESC, seq;

SELECT seq, seq-parent_seq, LPAD(' ', (LEVEL-1) * 4) || TITLE as title 
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq-parent_seq, seq DESC;

ALTER TABLE board_test ADD (gn number);

4번글 하위에 있는 모든글들
UPDATE board_test set gn = 2
WHERE seq IN (2,3);
COMMIT;


SELECT ename, sal, deptno
FROM emp 
ORDER BY deptno, sal DESC;
                
순위를 매길 대상 : emp 사원 => 14명
부서별로 인원이 다름
SELECT b.deptno, lv
FROM (SELECT LEVEL lv
FROM dual
CONNECT BY LEVEL <= (SELECT COUNT(*) FROm emp) a,

(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno) b
WHERE a.lv <= b.cnt
ORDER BY b.deptno, a.lv;

위와 동일한 동작을 하는 윈도우 함수
윈도우 함수 미사용 : emp 테이블 3번 조회
윈도우 함수 사용 : emp 테이블 1번 조회


SELECT ename, sal, deptno,
       RANK() OVER(PARTITION BY deptno ORDER BY sal desc) sal_rank
FROM emp;

윈도우 함수를 사용하면 행간 연산이 가능해짐
==> 일반적으로 풀리지 않는 쿼리를 간단하게 만들 수 있다.
** 모든 dbms가 동일한 윈도우 함수를 제공하지는 않음

문법 : 윈도우 함수 OVER ( [PARTITION BY 컬럼] [ORDER BY 컬럼] [WINDOWING])
PARTITION : 행들을 묶을 그룹 (그룹함수의 GROUP BY)
ORDER BY : 묶여진 행들간 순서 (RANK - 순위의 경우 순서를 설정하는 기준이 된다.)
WINDOWING : 파티션 안에서 특정 행들에 대해서만 연산을 하고 싶을 때 범위를 지정

순위 관련 함수
1. RANK() : 동일 값일 때는 동일 순위 부여, 후순위 중복자만큼 건너 띄고 부여
           1등이 2명이면 후순위는 3등
2. DENSE_RANK() : 동일 값일 때는 동일 순위, 후순위는 이어서 부여
                  1등이 2명이여도 후순위는 2등
3. ROW_NUMBER() : 중복되는 값이 없이 순위 부여 (rownum과 유사)

SELECT ename, sal, deptno,
       RANK() OVER(PARTITION BY deptno ORDER BY sal desc) sal_rank,
       DENSE_RANK() OVER(PARTITION BY deptno ORDER BY sal desc) sal_dense_rank,
       ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal desc) sal_row_rank
FROM emp;

no_ana2
SELECT a.*, b.cnt
FROM
(SELECT empno, ename, deptno
FROM emp)a,
(SELECT deptno ,COUNT(*) cnt
FROM emp
GROUP BY deptno)b
WHERE a.deptno = b.deptno
ORDER BY a.deptno, a.ename;

집계 윈도우 함수 : SUM, MAX, MIN, AVG, COUNT
SELECT empno, ename, deptno, COUNT(*) OVER (PARTITION BY deptno)cnt
FROM emp;

SELECT a.*, avg_sal
FROM
(SELECT empno, ename, sal, deptno
FROM emp) a,
(SELECT deptno, ROUND(AVG(sal),2) avg_sal
FROM emp
GROUP BY deptno) b
WHERE a.deptno = b.deptno;

ana_2
SELECT empno, ename, deptno, ROUND(AVG(sal) OVER (PARTITION BY deptno),2) avg_sal
FROM emp;
ana_3
SELECT empno, ename, deptno, MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;
ana_4
SELECT empno, ename, deptno, MIN(sal) OVER (PARTITION BY deptno) min_sal
FROM emp;
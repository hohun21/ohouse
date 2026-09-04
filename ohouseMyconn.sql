select * from member;

desc member;

SELECT SEQUENCE_NAME
FROM USER_SEQUENCES;

INSERT INTO MEMBER (
    MEMBER_ID,
    ID,
    NAME,
    PASSWORD,
    REG_DATE,
    RANK,
    ROLE
) VALUES (
    SEQ_MEMBER.NEXTVAL,
    'wtest',
    '탈퇴테슷',
    '1234',
    SYSDATE,
    'NORMAL',
    'USER'
);

SELECT
    SYS_CONTEXT('USERENV', 'DB_NAME') AS DB_NAME,
    SYS_CONTEXT('USERENV', 'SERVICE_NAME') AS SERVICE_NAME,
    USER AS USER_NAME
FROM DUAL;

SELECT id,password,member_id
FROM member
WHERE id = 'withdraw_test';

commit;

ALTER TABLE member
ADD status Number DEFAULT 1;

SELECT member_id, id, status
FROM member;
commit;

ALTER TABLE member
MODIFY status NUMBER DEFAULT 1 NOT NULL;
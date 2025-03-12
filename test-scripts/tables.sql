/*base*/

DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO pguser;
GRANT ALL ON SCHEMA public TO PUBLIC;


CREATE TYPE USER_ROLE AS ENUM (
    'admin',
    'client'
    );

CREATE TYPE TASK_STATUS AS ENUM (
    'pending',
    'complete',
    'archived'
    );


CREATE TYPE NOTIFICATION_TYPE AS ENUM (
    'task_approved_for_exec',
    'task_expired_for_exec',
    'task_expires_for_exec',
    'task_failed_for_exec',
    'task_completed_for_exec',
    'task_ordered_for_exec',
    'task_expired_for_cus',
    'task_failed_for_cus',
    'task_offered_for_cus',
    'post_new_for_exec',
    'post_new_for_cus',
    'search_new_for_exec',
    'search_new_for_cus',
    'profile_suggest_for_exec',
    'profile_suggest_for_cus'
    );
CREATE TABLE file
(
    path       TEXT UNIQUE PRIMARY KEY,
    created_at DATE NOT NULL
);

CREATE TABLE "user"
(
    id          SERIAL PRIMARY KEY,
    is_banned   BOOL      DEFAULT FALSE        NOT NULL,
    role        USER_ROLE DEFAULT 'client'     NOT NULL,
    name        VARCHAR(130) UNIQUE            NOT NULL,
    email       VARCHAR(255) UNIQUE            NOT NULL,
    password    VARCHAR(255)                   NOT NULL,
    firstname   VARCHAR(130)                   NOT NULL,
    lastname    VARCHAR(130),
    bio         VARCHAR(255),
    created_at  DATE      DEFAULT CURRENT_DATE NOT NULL,
    modified_at DATE      DEFAULT CURRENT_DATE NOT NULL
);

CREATE TABLE user_block
(
    blocking_id INTEGER REFERENCES "user" (id) NOT NULL,
    blocked_id  INTEGER REFERENCES "user" (id) NOT NULL,
    CONSTRAINT ub_pk PRIMARY KEY (blocking_id, blocked_id)
);

CREATE TABLE task
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(200)                   NOT NULL,
    user_id     INTEGER REFERENCES "user" (id) NOT NULL,
    description VARCHAR(6000)                  NOT NULL,
    task_status TASK_STATUS                    NOT NULL,
    created_at  DATE DEFAULT CURRENT_DATE      NOT NULL
);

CREATE TABLE task_offer
(
    user_id     INTEGER REFERENCES "user" (id) NOT NULL,
    task_id     INTEGER REFERENCES task (id)   NOT NULL,
    is_approved BOOL,
    created_at  DATE DEFAULT CURRENT_DATE      NOT NULL,
    CONSTRAINT tof_pk PRIMARY KEY (task_id, user_id)
);

CREATE TABLE task_order
(
    user_id     INTEGER REFERENCES "user" (id) NOT NULL,
    task_id     INTEGER REFERENCES task (id)   NOT NULL,
    is_approved BOOL,
    created_at  DATE DEFAULT CURRENT_DATE      NOT NULL,
    CONSTRAINT tor_pk PRIMARY KEY (task_id, user_id)
);

CREATE TABLE task_participant
(
    user_id     INTEGER REFERENCES "user" (id) NOT NULL,
    task_id     INTEGER REFERENCES task (id)   NOT NULL,
    is_complete BOOL                           NOT NULL,
    created_at  DATE DEFAULT CURRENT_DATE      NOT NULL,
    expires_at  DATE,
    CONSTRAINT tp_pk PRIMARY KEY (task_id, user_id)
);

CREATE TABLE post
(
    id          SERIAL PRIMARY KEY,
    body        VARCHAR(6000)                  NOT NULL,
    user_id     INTEGER REFERENCES "user" (id) NOT NULL,
    task_id     INTEGER REFERENCES task (id),
    created_at  DATE DEFAULT CURRENT_DATE      NOT NULL,
    modified_at DATE DEFAULT CURRENT_DATE      NOT NULL
);

CREATE TABLE post_review
(
    id          SERIAL PRIMARY KEY,
    body        VARCHAR(3000),
    user_id     INTEGER REFERENCES "user" (id) NOT NULL,
    post_id     INTEGER REFERENCES post (id)   NOT NULL,
    rate        INTEGER                        NOT NULL,
    created_at  DATE                           NOT NULL,
    modified_at DATE                           NOT NULL
);

CREATE TABLE post_review_like
(
    user_id   INTEGER REFERENCES "user" (id)      NOT NULL,
    review_id INTEGER REFERENCES post_review (id) NOT NULL,
    CONSTRAINT prl_pk PRIMARY KEY (review_id, user_id)
);


CREATE TABLE post_image
(
    path       TEXT REFERENCES file (path)  NOT NULL,
    post_id    INTEGER REFERENCES post (id) NOT NULL,
    created_at DATE                         NOT NULL,
    CONSTRAINT pimg_pk PRIMARY KEY (post_id, path)
);

CREATE TABLE user_image
(
    path       TEXT REFERENCES file (path)    NOT NULL,
    user_id    INTEGER REFERENCES "user" (id) NOT NULL,
    created_at DATE                           NOT NULL,
    CONSTRAINT uimg_pk PRIMARY KEY (user_id, path)
);

CREATE TABLE conversation
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(255),
    created_at DATE NOT NULL
);

CREATE TABLE conversation_participant
(
    user_id         INTEGER REFERENCES "user" (id)       NOT NULL,
    conversation_id INTEGER REFERENCES conversation (id) NOT NULL,
    CONSTRAINT cp_pk PRIMARY KEY (conversation_id, user_id)
);

CREATE TABLE conversation_message
(
    id              SERIAL PRIMARY KEY,
    conversation_id INTEGER REFERENCES conversation (id) NOT NULL,
    user_id         INTEGER REFERENCES "user" (id)       NOT NULL,
    body            VARCHAR(6000)                        NOT NULL,
    read            BOOL                                 NOT NULL,
    created_at      DATE                                 NOT NULL,
    modified_at     DATE                                 NOT NULL
);

CREATE TABLE conversation_file
(
    path            TEXT REFERENCES file (path)          NOT NULL,
    user_id         INTEGER REFERENCES "user" (id)       NOT NULL,
    conversation_id INTEGER REFERENCES conversation (id) NOT NULL,
    created_at      DATE                                 NOT NULL,
    CONSTRAINT cfile_pk PRIMARY KEY (user_id, conversation_id, path)
);

CREATE TABLE task_file
(
    path       TEXT REFERENCES file (path)  NOT NULL,
    task_id    INTEGER REFERENCES task (id) NOT NULL,
    created_at DATE                         NOT NULL,
    CONSTRAINT tfile_pk PRIMARY KEY (task_id, path)
);

CREATE TABLE conversation_image
(
    path            TEXT REFERENCES file (path)          NOT NULL,
    user_id         INTEGER REFERENCES "user" (id)       NOT NULL,
    conversation_id INTEGER REFERENCES conversation (id) NOT NULL,
    created_at      DATE                                 NOT NULL,
    CONSTRAINT cimg_pk PRIMARY KEY (user_id, conversation_id, path)
);

CREATE TABLE notification
(
    id           SERIAL PRIMARY KEY,
    type         NOTIFICATION_TYPE              NOT NULL,
    user_id      INTEGER REFERENCES "user" (id) NOT NULL,
    browser_link VARCHAR(400),
    is_read      BOOLEAN DEFAULT FALSE          NOT NULL,
    created_at   DATE    DEFAULT CURRENT_DATE   NOT NULL
);


INSERT INTO "user" (name, firstname, email, bio, password, role)
VALUES ('pashtet',
        'Alex',
        'pashtet@example.com',
        'тестовый юзер для платформы',
        'xxga',
        'admin');

INSERT INTO post (body, user_id)
VALUES ('Тестовый пост 1', 1),
       ('Тестовый пост 2', 1),
       ('Тестовый пост 3', 1);




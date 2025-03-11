/*base*/

CREATE TABLE user_roles /*admin, client*/
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE task_statuses /*pending, accomplished, archived*/
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE users
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100) UNIQUE                NOT NULL,
    email       VARCHAR(200) UNIQUE                NOT NULL,
    description VARCHAR(200)                       NOT NULL,
    password    TEXT                               NOT NULL,
    role_id     INTEGER REFERENCES user_roles (id) NOT NULL,
    created_at  DATE                               NOT NULL,
    modified_at DATE                               NOT NULL,
    is_banned   BOOL
);

CREATE TABLE tasks
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(200)                  NOT NULL,
    user_id     INTEGER REFERENCES users (id) NOT NULL,
    description VARCHAR(6000)                 NOT NULL
);


CREATE TABLE task_requests
(
    user_id     INTEGER REFERENCES users (id) NOT NULL,
    task_id     INTEGER REFERENCES tasks (id) NOT NULL,
    is_approved BOOL                          NOT NULL,
    CONSTRAINT tr_pk PRIMARY KEY (task_id, user_id)
);

CREATE TABLE task_participants
(
    user_id     INTEGER REFERENCES users (id) NOT NULL,
    task_id     INTEGER REFERENCES tasks (id) NOT NULL,
    is_complete BOOL                          NOT NULL,
    CONSTRAINT tp_pk PRIMARY KEY (task_id, user_id)
);

CREATE TABLE posts
(
    id      SERIAL PRIMARY KEY,
    body    VARCHAR(6000)                 NOT NULL,
    user_id INTEGER REFERENCES users (id) NOT NULL,
    task_id INTEGER REFERENCES tasks (id)
);

CREATE TABLE post_reviews
(
    id          SERIAL PRIMARY KEY,
    body        VARCHAR(3000),
    user_id     INTEGER REFERENCES users (id) NOT NULL,
    post_id     INTEGER REFERENCES posts (id) NOT NULL,
    rate        INTEGER                       NOT NULL,
    created_at  DATE                          NOT NULL,
    modified_at DATE                          NOT NULL
);

CREATE TABLE post_reviews_likes
(
    user_id   INTEGER REFERENCES users (id)        NOT NULL,
    review_id INTEGER REFERENCES post_reviews (id) NOT NULL,
    CONSTRAINT prl_pk PRIMARY KEY (review_id, user_id)
);

CREATE TABLE post_images
(
    path       TEXT                          NOT NULL PRIMARY KEY,
    post_id    INTEGER REFERENCES posts (id) NOT NULL,
    created_at DATE                          NOT NULL
);


CREATE TABLE user_images
(
    path       TEXT                          NOT NULL PRIMARY KEY,
    user_id    INTEGER REFERENCES users (id) NOT NULL,
    created_at DATE                          NOT NULL
);

CREATE TABLE conversations
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(255),
    created_at DATE NOT NULL
);

CREATE TABLE conversation_participants
(
    user_id         INTEGER REFERENCES users (id)         NOT NULL,
    conversation_id INTEGER REFERENCES conversations (id) NOT NULL,
    CONSTRAINT cp_pk PRIMARY KEY (conversation_id, user_id)
);

CREATE TABLE conversation_messages
(
    id              SERIAL PRIMARY KEY,
    conversation_id INTEGER REFERENCES conversations (id) NOT NULL,
    user_id         INTEGER REFERENCES users (id)         NOT NULL,
    body            TEXT                                  NOT NULL,
    read            BOOL                                  NOT NULL,
    created_at      DATE                                  NOT NULL,
    modified_at     DATE                                  NOT NULL
);

CREATE TABLE conversation_message_files
(
    path       TEXT PRIMARY KEY,
    message_id INTEGER REFERENCES conversation_messages (id) NOT NULL,
    created_at DATE                                          NOT NULL
);

CREATE TABLE notification_types
(
    id    VARCHAR(50) PRIMARY KEY,
    title VARCHAR(100) UNIQUE NOT NULL,
    body  TEXT                NOT NULL
);

CREATE TABLE notifications
(
    id        SERIAL PRIMARY KEY,
    type_id   VARCHAR(50) REFERENCES notification_types (id) NOT NULL,
    user_id   INTEGER REFERENCES users (id)                  NOT NULL,
    object_id INTEGER
);

INSERT INTO user_roles (name)
VALUES ('admin'),
       ('client');

INSERT INTO users (name, email, description, password, role_id, created_at, modified_at, is_banned)
VALUES ('pashtet',
        'pashtet@example.com',
        'тестовый юзер для платформы',
        'xxga',
        2,
        CURRENT_DATE,
        CURRENT_DATE,
        FALSE);

INSERT INTO posts (body, user_id)
VALUES ('Тестовый пост 1', 1),
       ('Тестовый пост 2', 1),
       ('Тестовый пост 3', 1);




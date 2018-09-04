-- 创建微博数据表 --
CREATE TABLE IF NOT EXISTS T_Status (
    statusId integer,
    userId integer(128),
    status text(128) NOT NULL,
    PRIMARY KEY(statusId, userId)
);

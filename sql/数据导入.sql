-- 1) 由于数据量较大，先完成数据准备：建立 6 张字段对应的表，并通过 LOAD DATA 导入 CSV，为后续宽表关联做准备；也可视情况使用 Navicat 手动导入。
DROP TABLE IF EXISTS ub_labels;
CREATE TABLE ub_labels (
    user_id         BIGINT,
    goods_id        BIGINT,
    category_id     BIGINT,
    behavior        VARCHAR(8),
    `timestamp`     VARCHAR(32),        
    sex             VARCHAR(8),
    address         VARCHAR(32),
    device          VARCHAR(32),
    price           DECIMAL(10,2),
    amount          DECIMAL(4,1),       
    `comment`       TEXT,
    `time`          DATETIME,
    `date`          DATE,
    `hour`          TINYINT,
    pv_count        TINYINT,
    cart_count      TINYINT,
    fav_count       TINYINT,
    buy_count       TINYINT,
    cluster         TINYINT,
    user_type_label VARCHAR(32)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS user_face;
CREATE TABLE user_face (
    user_id BIGINT,
    face    VARCHAR(64)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS category_mapping;
CREATE TABLE category_mapping (
    category_id    BIGINT,
    category_count INT,
    category_label VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS goods_mapping;
CREATE TABLE goods_mapping (
    goods_id    BIGINT,
    goods_count INT,
    goods_name  VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS goods_category_count;
CREATE TABLE goods_category_count (
    goods_id    BIGINT,
    category_id BIGINT,
    goods_count INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS user_comments;
CREATE TABLE user_comments (
    user_id     BIGINT,
    goods_id    BIGINT,
    category_id BIGINT,
    `comment`   TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2)主表导入
LOAD DATA LOCAL INFILE 'C:/Users/81599/Desktop/archive/ub_labels.csv'
INTO TABLE ub_labels
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '\\'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(user_id, goods_id, category_id, behavior, `timestamp`, sex, address, device,
 price, amount, `comment`, `time`, `date`, `hour`,
 pv_count, cart_count, fav_count, buy_count, cluster, user_type_label);

-- 3) 用户画像表导入
LOAD DATA LOCAL INFILE 'C:/Users/81599/Desktop/archive/user_face.csv'
INTO TABLE user_face
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '\\'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(user_id, face);

-- 4) 类目表导入 
LOAD DATA LOCAL INFILE 'C:/Users/81599/Desktop/archive/category_mapping.csv'
INTO TABLE category_mapping
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '\\'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(category_id, category_count, category_label);

-- 5) 商品表导入 
LOAD DATA LOCAL INFILE 'C:/Users/81599/Desktop/archive/goods_mapping.csv'
INTO TABLE goods_mapping
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '\\'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(goods_id, goods_count, goods_name);

-- 6) 商品-类目表导入
LOAD DATA LOCAL INFILE 'C:/Users/81599/Desktop/archive/goods_category_count.csv'
INTO TABLE goods_category_count
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '\\'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(goods_id, category_id, goods_count);

-- 7) 评论表导入
LOAD DATA LOCAL INFILE 'C:/Users/81599/Desktop/archive/user_comments.csv'
INTO TABLE user_comments
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '\\'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(user_id, goods_id, category_id, `comment`);

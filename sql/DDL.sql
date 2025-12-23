-- =============================================
-- MySQL 完整初始化脚本（无Oracle专属语法）
-- 功能：食堂管理系统数据库+用户+表+测试数据一站式创建
-- =============================================

-- 1. 创建数据库（不存在则创建，指定UTF-8编码）
CREATE DATABASE IF NOT EXISTS canteen_management 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- 2. 切换到目标数据库
USE canteen_management;

-- 3. 创建业务用户（替换原Oracle风格的root用户创建，适配MySQL）
-- 先删除已存在的用户（避免冲突）
DROP USER IF EXISTS 'canteen_user'@'%';
-- 创建用户（%允许远程连接，本地连接可改为'localhost'）
CREATE USER 'canteen_user'@'%' IDENTIFIED BY 'Canteen@123456'; -- 安全密码
-- 授予业务库全部操作权限（最小权限原则，仅开放canteen_management库）
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX 
ON canteen_management.* TO 'canteen_user'@'%';
-- 刷新权限使其生效
FLUSH PRIVILEGES;

-- =============================================
-- 4. 核心表结构创建（MySQL语法，无表空间、无Oracle专属约束）
-- =============================================

-- 用户表（myUser）
CREATE TABLE IF NOT EXISTS myUser (
    userId      BIGINT AUTO_INCREMENT COMMENT '用户ID（主键）',
    name        VARCHAR(25) NOT NULL COMMENT '真实姓名',
    username    VARCHAR(25) NOT NULL COMMENT '登录用户名（唯一）',
    password    VARCHAR(64) NOT NULL COMMENT '登录密码（SHA256加密）',
    sex         VARCHAR(10) NOT NULL COMMENT '性别（男/女/未知）',
    telephone   VARCHAR(20) NOT NULL COMMENT '联系电话',
    department  VARCHAR(25) NOT NULL COMMENT '所属部门',
    role        VARCHAR(25) NOT NULL COMMENT '角色（manager/chef/caterer/treasurer/staff）',
    createTime  DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    -- 主键和唯一约束
    CONSTRAINT PK_MYUSER_USERID PRIMARY KEY(userId),
    CONSTRAINT UK_MYUSER_USERNAME UNIQUE(username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统用户表';

-- 食谱表（recipe）
CREATE TABLE IF NOT EXISTS recipe (
    recipeId    BIGINT AUTO_INCREMENT COMMENT '食谱ID（主键）',
    name        VARCHAR(25) NOT NULL COMMENT '食谱名称',
    category    VARCHAR(25) NOT NULL COMMENT '分类（菜肴/甜点/主食/饮品）',
    picture     VARCHAR(100) COMMENT '食谱图片路径',
    unit        VARCHAR(10) NOT NULL COMMENT '计量单位（份/两/个/杯）',
    price       DECIMAL(18,2) NOT NULL COMMENT '单价',
    description VARCHAR(200) NOT NULL COMMENT '食谱描述',
    createTime  DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    CONSTRAINT PK_RECIPE_RECIPEID PRIMARY KEY(recipeId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='食谱信息表';

-- 菜单表（menu）
CREATE TABLE IF NOT EXISTS menu (
    menuId      BIGINT AUTO_INCREMENT COMMENT '菜单ID（主键）',
    name        VARCHAR(25) NOT NULL COMMENT '菜单名称',
    category    VARCHAR(25) NOT NULL COMMENT '分类（菜肴/甜点/主食/饮品）',
    picture     VARCHAR(100) COMMENT '菜单图片路径',
    unit        VARCHAR(10) NOT NULL COMMENT '计量单位（份/两/个/杯）',
    price       DECIMAL(18,2) NOT NULL COMMENT '单价',
    createTime  DATETIME NOT NULL COMMENT '上架时间',
    recipeId    BIGINT COMMENT '关联食谱ID（外键）',
    CONSTRAINT PK_MENU_MENUID PRIMARY KEY(menuId),
    CONSTRAINT FK_MENU_RECIPEID FOREIGN KEY(recipeId) REFERENCES recipe(recipeId) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='当前可点餐菜单表';

-- 历史菜单表（history）
CREATE TABLE IF NOT EXISTS history (
    hisId       BIGINT AUTO_INCREMENT COMMENT '历史记录ID（主键）',
    timeRange   VARCHAR(50) NOT NULL COMMENT '时间范围（如：2025-11-24 午餐）',
    menuIds     VARCHAR(500) NOT NULL COMMENT '关联菜单ID集合（逗号分隔）',
    createTime  DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
    CONSTRAINT PK_HISTORY_HISID PRIMARY KEY(hisId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='历史菜单记录表';

-- 订单表（orderForm）
CREATE TABLE IF NOT EXISTS orderForm (
    orderId     BIGINT AUTO_INCREMENT COMMENT '订单ID（主键）',
    userId      BIGINT NOT NULL COMMENT '下单用户ID（外键）',
    name        VARCHAR(25) NOT NULL COMMENT '收货人姓名',
    telephone   VARCHAR(20) NOT NULL COMMENT '收货人电话',
    orderTime   DATETIME NOT NULL COMMENT '下单时间',
    orderPrice  DECIMAL(18,2) NOT NULL COMMENT '订单总金额',
    status      VARCHAR(20) DEFAULT '待支付' COMMENT '订单状态（待支付/已支付/已取消/已完成）',
    CONSTRAINT PK_ORDERFORM_ORDERID PRIMARY KEY(orderId),
    CONSTRAINT FK_ORDERFORM_USERID FOREIGN KEY(userId) REFERENCES myUser(userId) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单主表';

-- 总括订单表（blanketOrder）- 订单明细表
CREATE TABLE IF NOT EXISTS blanketOrder (
    mealId      BIGINT AUTO_INCREMENT COMMENT '明细ID（主键）',
    orderId     BIGINT NOT NULL COMMENT '关联订单ID（外键）',
    name        VARCHAR(25) NOT NULL COMMENT '菜品名称',
    unit        VARCHAR(10) NOT NULL COMMENT '计量单位（份/两/个/杯）',
    weight      DECIMAL(8,2) COMMENT '重量（可选）',
    price       DECIMAL(18,2) NOT NULL COMMENT '单品单价',
    quantity    INT NOT NULL DEFAULT 1 COMMENT '购买数量',
    totalPrice  DECIMAL(18,2) NOT NULL COMMENT '单品总金额（单价×数量）',
    createTime  DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    CONSTRAINT PK_BO_MEALID PRIMARY KEY(mealId),
    CONSTRAINT FK_BO_ORDERID FOREIGN KEY(orderId) REFERENCES orderForm(orderId) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单明细表';

-- 购物车表（shopCart）
CREATE TABLE IF NOT EXISTS shopCart (
    scId        BIGINT AUTO_INCREMENT COMMENT '购物车ID（主键）',
    userId      BIGINT NOT NULL COMMENT '所属用户ID（外键）',
    menuId      BIGINT COMMENT '关联菜单ID（外键）',
    name        VARCHAR(25) NOT NULL COMMENT '菜品名称',
    unit        VARCHAR(10) NOT NULL COMMENT '计量单位（份/两/个/杯）',
    weight      DECIMAL(8,2) COMMENT '重量（可选）',
    price       DECIMAL(18,2) NOT NULL COMMENT '单价',
    quantity    INT NOT NULL DEFAULT 1 COMMENT '加入数量',
    totalPrice  DECIMAL(18,2) NOT NULL COMMENT '小计金额（单价×数量）',
    picture     VARCHAR(100) COMMENT '菜品图片路径',
    createTime  DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
    updateTime  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    CONSTRAINT PK_SC_SCID PRIMARY KEY(scId),
    CONSTRAINT FK_SC_USERID FOREIGN KEY(userId) REFERENCES myUser(userId) ON DELETE CASCADE,
    CONSTRAINT FK_SC_MENUID FOREIGN KEY(menuId) REFERENCES menu(menuId) ON DELETE SET NULL,
    CONSTRAINT UK_SC_USER_MENU UNIQUE(userId, menuId) -- 同一用户同一菜品不重复
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户购物车表';

-- 销售统计表（sale）
CREATE TABLE IF NOT EXISTS sale (
    saleId      BIGINT AUTO_INCREMENT COMMENT '统计ID（主键）',
    year        INT NOT NULL COMMENT '统计年份（如：2025）',
    month       INT NOT NULL COMMENT '统计月份（如：11）',
    totalOrder  INT NOT NULL DEFAULT 0 COMMENT '当月订单数',
    totalPrice  DECIMAL(18,2) NOT NULL DEFAULT 0.00 COMMENT '当月销售总额',
    createTime  DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '统计生成时间',
    CONSTRAINT PK_SALE_SALEID PRIMARY KEY(saleId),
    CONSTRAINT UK_SALE_YEAR_MONTH UNIQUE(year, month) -- 年月唯一，避免重复统计
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='销售月度统计表';

-- =============================================
-- 5. 插入测试数据（MySQL兼容语法）
-- =============================================

-- 插入管理员用户（密码：123456，SHA256加密存储）
INSERT INTO myUser (name, username, password, sex, telephone, department, role)
VALUES (
    '系统管理员', 
    'manager', 
    SHA2('123456', 256), -- MySQL内置SHA256加密函数
    '男', 
    '15712131178', 
    '财务部', 
    'manager'
) ON DUPLICATE KEY UPDATE 
    name='系统管理员', telephone='15712131178', department='财务部', role='manager';

-- 插入测试食谱
INSERT INTO recipe (name, category, unit, price, description)
VALUES 
('宫保鸡丁', '菜肴', '份', 28.00, '经典川菜，鸡肉鲜嫩，花生酥脆'),
('提拉米苏', '甜点', '份', 18.00, '意大利甜点，咖啡味浓郁'),
('白米饭', '主食', '份', 3.00, '香喷喷的白米饭'),
('柠檬红茶', '饮品', '杯', 12.00, '鲜榨柠檬+红茶，清爽解腻')
ON DUPLICATE KEY UPDATE price=VALUES(price), description=VALUES(description);

-- 插入测试菜单（关联食谱）
INSERT INTO menu (name, category, picture, unit, price, createTime, recipeId)
SELECT 
    r.name, 
    r.category, 
    CONCAT('/images/menu/', r.name, '.jpg'), -- 模拟图片路径
    r.unit, 
    r.price, 
    NOW(), -- MySQL获取当前时间函数
    r.recipeId
FROM recipe r
ON DUPLICATE KEY UPDATE price=VALUES(price), createTime=VALUES(createTime);

-- 插入测试历史菜单
INSERT INTO history (timeRange, menuIds)
VALUES ('2025-11-24 午餐', '1,2,3,4') -- 关联上面插入的4个菜单ID
ON DUPLICATE KEY UPDATE menuIds=VALUES(menuIds);

-- 插入测试订单
INSERT INTO orderForm (userId, name, telephone, orderTime, orderPrice, status)
VALUES (1, '系统管理员', '15712131178', NOW(), 61.00, '已支付')
ON DUPLICATE KEY UPDATE orderPrice=VALUES(orderPrice), status=VALUES(status);

-- 插入订单明细（关联订单ID=1）
INSERT INTO blanketOrder (orderId, name, unit, price, quantity, totalPrice)
VALUES 
(1, '宫保鸡丁', '份', 28.00, 1, 28.00),
(1, '提拉米苏', '份', 18.00, 1, 18.00),
(1, '柠檬红茶', '杯', 12.00, 1, 12.00)
ON DUPLICATE KEY UPDATE quantity=VALUES(quantity), totalPrice=VALUES(totalPrice);

-- 插入测试购物车数据
INSERT INTO shopCart (userId, menuId, name, unit, price, quantity, totalPrice, picture)
SELECT 
    1, 
    m.menuId, 
    m.name, 
    m.unit, 
    m.price, 
    2, 
    m.price*2, 
    m.picture
FROM menu m WHERE m.name='白米饭'
ON DUPLICATE KEY UPDATE quantity=2, totalPrice=VALUES(totalPrice);

-- 插入11月销售统计
INSERT INTO sale (year, month, totalOrder, totalPrice)
VALUES (2025, 11, 1, 61.00)
ON DUPLICATE KEY UPDATE totalOrder=totalOrder+1, totalPrice=totalPrice+VALUES(totalPrice);

-- =============================================
-- 6. 数据验证查询（执行后可查看结果）
-- =============================================
SELECT '===== 用户表数据 =====' AS 验证结果;
SELECT userId, username, name, role FROM myUser;

SELECT '\n===== 菜单表数据 =====' AS 验证结果;
SELECT menuId, name, category, price FROM menu;

SELECT '\n===== 订单表数据 =====' AS 验证结果;
SELECT orderId, userId, orderPrice, status FROM orderForm;

SELECT '\n===== 订单明细表数据 =====' AS 验证结果;
SELECT mealId, orderId, name, quantity, totalPrice FROM blanketOrder;
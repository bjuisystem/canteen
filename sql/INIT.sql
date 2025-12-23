-------------------------------------
-- INIT.sql（MySQL版本）
-- 初始化用户表信息、食谱信息
-- 修正点：移除Oracle的chr(10)，改用MySQL的\n换行；保持字段顺序和表结构一致
-------------------------------------

-- 用户表初始化（兼容MySQL，字段顺序匹配myUser表）
INSERT INTO myUser (userId, name, username, password, sex, telephone, department, role)
VALUES (1588202087768961025, '员工', 'staff2', SHA2('123456', 256), '男', '15789653205', '技术部', 'staff')
ON DUPLICATE KEY UPDATE password=SHA2('123456', 256), telephone='15789653205';

INSERT INTO myUser (userId, name, username, password, sex, telephone, department, role)
VALUES (1595067017944141825, 'staff3', 'staff3', SHA2('123456', 256), '男', '12345678911', '技术部', 'staff')
ON DUPLICATE KEY UPDATE password=SHA2('123456', 256), telephone='12345678911';

INSERT INTO myUser (userId, name, username, password, sex, telephone, department, role)
VALUES (1580717067441590273, 'chef', 'chef', SHA2('123456', 256), '男', '12501336501', '生产部', 'chef')
ON DUPLICATE KEY UPDATE password=SHA2('123456', 256), telephone='12501336501';

INSERT INTO myUser (userId, name, username, password, sex, telephone, department, role)
VALUES (1580717246668394498, 'caterer', 'caterer', SHA2('123456', 256), '女', '14523532178', '生产部', 'caterer')
ON DUPLICATE KEY UPDATE password=SHA2('123456', 256), telephone='14523532178';

INSERT INTO myUser (userId, name, username, password, sex, telephone, department, role)
VALUES (1580717341635825665, 'treasurer', 'treasurer', SHA2('123456', 256), '女', '16253401289', '财务部', 'treasurer')
ON DUPLICATE KEY UPDATE password=SHA2('123456', 256), telephone='16253401289';

INSERT INTO myUser (userId, name, username, password, sex, telephone, department, role)
VALUES (1580717435110084610, 'staff', 'staff', SHA2('123456', 256), '女', '12301572301', '营销部', 'staff')
ON DUPLICATE KEY UPDATE password=SHA2('123456', 256), telephone='12301572301';

INSERT INTO myUser (userId, name, username, password, sex, telephone, department, role)
VALUES (1595067112211124225, 'staff4', 'staff4', SHA2('123456', 256), '女', '12345678999', '生产部', 'staff')
ON DUPLICATE KEY UPDATE password=SHA2('123456', 256), telephone='12345678999';

INSERT INTO myUser (userId, name, username, password, sex, telephone, department, role)
VALUES (1397849739276890114, 'manager', 'manager', SHA2('123456', 256), '男', '15712131178', '财务部', 'manager')
ON DUPLICATE KEY UPDATE password=SHA2('123456', 256), telephone='15712131178';

-- 食谱表初始化（兼容MySQL，修正换行符chr(10)为\n）
INSERT INTO recipe (recipeId, name, category, picture, unit, price, description)
VALUES (1586742596993060865, '烤鸭', '菜肴', 'eae0bf1a-48e2-4d97-929c-688ed4fa1c9a.jpeg', '份', 66.00, '烤鸭')
ON DUPLICATE KEY UPDATE price=66.00, description='烤鸭';

INSERT INTO recipe (recipeId, name, category, picture, unit, price, description)
VALUES (1582032939984637953, '鱼香肉丝', '菜肴', '9912c6b3-f8dd-4933-8e43-37c5de85392d.jpg', '份', 47.00, '味道：甜辣\n食材：肉丝、....')
ON DUPLICATE KEY UPDATE price=47.00, description='味道：甜辣\n食材：肉丝、....';

INSERT INTO recipe (recipeId, name, category, picture, unit, price, description)
VALUES (1582030292502228993, '麻辣兔头', '菜肴', 'd3495803-e1a5-40c2-bb83-904b4034dd84.jpg', '份', 53.00, '味道：麻辣\n食材：辣椒、兔头')
ON DUPLICATE KEY UPDATE price=53.00, description='味道：麻辣\n食材：辣椒、兔头';

INSERT INTO recipe (recipeId, name, category, picture, unit, price, description)
VALUES (1585297767641706498, '北冰洋', '饮品', '83a48e56-53a1-40af-873a-b095ee1cbad9.png', '杯', 3.00, '北冰洋，冰的，解渴')
ON DUPLICATE KEY UPDATE price=3.00, description='北冰洋，冰的，解渴';

INSERT INTO recipe (recipeId, name, category, picture, unit, price, description)
VALUES (1585298235453403138, '烤乳鸽', '菜肴', '8f62c8bd-8bb7-49ff-95d6-097bbb8a376c.jpeg', '份', 88.00, '脆皮烤乳鸽')
ON DUPLICATE KEY UPDATE price=88.00, description='脆皮烤乳鸽';

INSERT INTO recipe (recipeId, name, category, picture, unit, price, description)
VALUES (1585298352906498049, '王老吉', '饮品', '195c3c20-45d4-44ff-9308-57a89d9fec97.png', '杯', 5.00, '王老吉凉茶')
ON DUPLICATE KEY UPDATE price=5.00, description='王老吉凉茶';

INSERT INTO recipe (recipeId, name, category, picture, unit, price, description)
VALUES (1585298610474512386, '上汤焗龙虾', '菜肴', '705f71c1-a45c-45da-8181-070c5c455785.jpeg', '份', 199.00, '上汤焗龙虾')
ON DUPLICATE KEY UPDATE price=199.00, description='上汤焗龙虾';

INSERT INTO recipe (recipeId, name, category, picture, unit, price, description)
VALUES (1585298746118303745, '东坡肉', '菜肴', 'e8a943c1-4534-47bc-a5bf-a198048e68c4.jpg', '份', 89.00, '糯糯的东坡肉')
ON DUPLICATE KEY UPDATE price=89.00, description='糯糯的东坡肉';

INSERT INTO recipe (recipeId, name, category, picture, unit, price, description)
VALUES (1585298953925095426, '蘑菇汤', '饮品', '726c1de4-03b9-4340-9593-0d58683df9a1.jpeg', '份', 128.00, '清淡蘑菇汤')
ON DUPLICATE KEY UPDATE price=128.00, description='清淡蘑菇汤';

INSERT INTO recipe (recipeId, name, category, picture, unit, price, description)
VALUES (1585299248528814081, '血肠', '甜点', '12c0fac3-6be7-4453-b540-b5083956f7da.jpg', '两', 35.00, '血肠血肠血肠')
ON DUPLICATE KEY UPDATE price=35.00, description='血肠血肠血肠';

INSERT INTO recipe (recipeId, name, category, picture, unit, price, description)
VALUES (1585300202267406338, '白切鸡', '菜肴', '7a481644-cb81-4ec4-894b-376297ba57a4.jpeg', '份', 68.00, '半只白切鸡')
ON DUPLICATE KEY UPDATE price=68.00, description='半只白切鸡';

INSERT INTO recipe (recipeId, name, category, picture, unit, price, description)
VALUES (1585300388796493826, '甜品吧', '甜点', '7c51fb88-2c15-46ee-9748-f8973a041107.jpg', '个', 12.00, '应该是甜品吧')
ON DUPLICATE KEY UPDATE price=12.00, description='应该是甜品吧';

INSERT INTO recipe (recipeId, name, category, picture, unit, price, description)
VALUES (1582634905643323394, '米饭', '主食', '3e79736f-c299-49a6-8870-e945a584611e.png', '份', 3.00, '就米饭呗')
ON DUPLICATE KEY UPDATE price=3.00, description='就米饭呗';

-- 插入完成后验证数据（可选）
SELECT '===== 用户表初始化完成，共' || COUNT(*) || '条数据 =====' AS 初始化结果 FROM myUser;
SELECT '===== 食谱表初始化完成，共' || COUNT(*) || '条数据 =====' AS 初始化结果 FROM recipe;
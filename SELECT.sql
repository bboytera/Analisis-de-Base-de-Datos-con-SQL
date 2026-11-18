-- MySQL 8.0.16+: executable queries only.
-- stock defaults to 0; inventory values require actual stock data.

-- Query 1
SELECT product_id, name, price, stock
FROM products
WHERE price <= 100
AND stock > 50
ORDER BY stock DESC;

-- Query 2
SELECT product_id, name, price, stock,
price * stock as total
FROM products
WHERE price <= 100
AND stock > 50
ORDER BY total DESC;

-- Query 3
SELECT product_id, name, price, stock,
round(price * stock) as total
FROM products
ORDER BY total DESC
LIMIT 10;

-- Query 4
SELECT COUNT(*) FROM products;

-- Query 5
SELECT COUNT(*) FROM products
WHERE price <= 500;

-- Query 6
SELECT SUM(stock) FROM products;

-- Query 7
SELECT round(AVG(price)) FROM products;

-- Query 8
SELECT SUM(price*stock) FROM products;

-- Query 9
SELECT
    CASE
        WHEN email LIKE '%@gmail.com' THEN 'gmail'
        WHEN email LIKE '%@yahoo.com' THEN 'yahoo'
        WHEN email LIKE '%@hotmail.com' THEN 'hotmail'
        ELSE 'otro proveedor de correo'
    END AS proveedor,
    COUNT(*) AS total_clients
FROM clients
GROUP BY proveedor
ORDER BY total_clients DESC;

-- Query 10
SELECT b.bill_id, b.status, c.name,
       COUNT(bp.bill_product_id) AS number_of_lines,
       COALESCE(ROUND(SUM(bp.quantity * bp.price * (1 - bp.discount / 100.0)), 2), 0) AS total
FROM bills AS b
LEFT JOIN clients AS c ON b.client_id = c.client_id
LEFT JOIN bill_products AS bp ON bp.bill_id = b.bill_id
GROUP BY b.bill_id, b.status, c.name
ORDER BY b.bill_id;

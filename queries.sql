-- Inventory & Supplier Scorecard — sample dataset
-- Tables:
--   items     (item_id, item_name, category, supplier_id, unit_cost,
--              qty_on_hand, reorder_point)
--   suppliers (supplier_id, supplier_name)
--   deliveries(delivery_id, supplier_id, item_id, promised_date,
--              received_date, qty_received)
--   sales     (sale_id, item_id, sale_date, quantity)
-- Definitions: on time = received_date <= promised_date.
-- Slow-moving = no sale in the last 90 days (or never sold).

-- ============================================================
-- 1. Reorder list: items at or below their reorder point,
--    most urgent first
-- ============================================================
SELECT
    i.item_id,
    i.item_name,
    i.category,
    s.supplier_name,
    i.qty_on_hand,
    i.reorder_point,
    i.reorder_point - i.qty_on_hand     AS units_below_point,
    ROUND(i.qty_on_hand * 100.0
          / NULLIF(i.reorder_point, 0), 0) AS pct_of_reorder_point
FROM items i
JOIN suppliers s ON s.supplier_id = i.supplier_id
WHERE i.qty_on_hand <= i.reorder_point
ORDER BY units_below_point DESC, i.item_name;

-- ============================================================
-- 2. Supplier scorecard: on-time delivery rate per supplier,
--    with average days late on the deliveries that missed
-- ============================================================
SELECT
    s.supplier_name,
    COUNT(*)                                                    AS deliveries,
    SUM(CASE WHEN d.received_date <= d.promised_date
             THEN 1 ELSE 0 END)                                 AS on_time,
    ROUND(100.0 * SUM(CASE WHEN d.received_date <= d.promised_date
                           THEN 1 ELSE 0 END)
          / COUNT(*), 1)                                        AS on_time_pct,
    ROUND(AVG(CASE WHEN d.received_date > d.promised_date
                   THEN d.received_date - d.promised_date END), 1)
                                                                AS avg_days_late,
    SUM(d.qty_received)                                         AS total_units_received
FROM deliveries d
JOIN suppliers s ON s.supplier_id = d.supplier_id
GROUP BY s.supplier_name
ORDER BY on_time_pct DESC;

-- ============================================================
-- 3. Slow-moving items: no sale in 90+ days (or never sold),
--    with the stock value tied up in each
-- ============================================================
SELECT
    i.item_id,
    i.item_name,
    i.category,
    s.supplier_name,
    MAX(sa.sale_date)                       AS last_sale_date,
    i.qty_on_hand,
    i.unit_cost,
    i.qty_on_hand * i.unit_cost             AS stock_value_tied_up
FROM items i
JOIN suppliers s ON s.supplier_id = i.supplier_id
LEFT JOIN sales sa ON sa.item_id = i.item_id
GROUP BY i.item_id, i.item_name, i.category, s.supplier_name,
         i.qty_on_hand, i.unit_cost
HAVING MAX(sa.sale_date) IS NULL
    OR MAX(sa.sale_date) < CURRENT_DATE - INTERVAL '90 days'
ORDER BY stock_value_tied_up DESC;

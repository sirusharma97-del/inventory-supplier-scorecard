# Inventory & Supplier Scorecard (SQL)

Inventory and supplier checks in SQL: what is about to run out, which
suppliers deliver on time, and which stock has stopped moving — the three
lists an operations team reviews before placing orders.

All data is sample/practice data created for portfolio purposes. No real
company, inventory, or supplier data is used anywhere in this project.

## The questions it answers

1. Which items are at or below their reorder point right now?
   (stock levels vs. reorder point)
2. How reliable is each supplier — what percentage of their deliveries
   arrived on or before the promised date? (supplier on-time rate)
3. Which items have not sold in 90+ days, and how much stock value is
   sitting in them? (slow-moving items)

## Tables

- `items` (item_id, item_name, category, supplier_id, unit_cost,
  qty_on_hand, reorder_point)
- `suppliers` (supplier_id, supplier_name)
- `deliveries` (delivery_id, supplier_id, item_id, promised_date,
  received_date, qty_received)
- `sales` (sale_id, item_id, sale_date, quantity)

A delivery counts as **on time** when `received_date <= promised_date`.
An item is **slow-moving** when it has no sale in the last 90 days (or has
never sold). Stock value tied up = `qty_on_hand × unit_cost`.

## What was done

- Compared `qty_on_hand` to `reorder_point` and ranked the reorder list
  by how far below the point each item sits, so the most urgent items
  come first.
- Calculated each supplier's on-time percentage with conditional
  aggregation over their deliveries, alongside total deliveries and
  average days late for the ones that missed.
- Found slow-moving items with a `LEFT JOIN` against recent sales, and
  valued the stock sitting in them so the list can be prioritized in
  dollars, not just unit counts.

## Skills shown

- SQL joins across four tables, including a `LEFT JOIN` to find what is
  *missing* (items with no recent sales)
- Conditional aggregation for percentage scorecards
- Operational definitions (on time, reorder point, slow-moving) stated
  before the queries that use them

## Files

- `README.md` — this file
- `queries.sql` — the three scorecard queries, commented section by section

# Analysis — Inventory & Supplier Scorecard

**Sample data.** Every figure below was computed from the generated sample
dataset in `data/` (24 items, 5 suppliers, 77 deliveries, 472 sales rows,
Dec 2025 – Oct 2026). It is practice data — no real inventory or supplier
data is used. Definitions match `queries.sql`: on time means received on
or before the promised date; slow-moving means no sale in the 90 days
before 2026-10-31 (or never sold); stock value is quantity on hand × unit
cost.

## Business questions

1. What needs reordering right now, and what is most urgent?
2. Which suppliers keep their promises — and what does a miss look like?
3. Where is cash sitting in stock that has stopped selling?

## Key findings

1. **Almost half the catalog is at or below its reorder point.** 11 of
   24 items (45.8%) need reordering. The most urgent is Ballpoint Pens:
   15 units on hand against a 60-unit reorder point — 45 units below the
   point, at just 25% of the level that should trigger an order. HDMI
   Cables (21 below) and Disinfecting Wipes (19 below) follow.
2. **Supplier reliability splits the list in two.** Overall on-time
   delivery is 68.8%. Pacific Office Supply (85.0% on time, 20
   deliveries) and GreatLakes Wholesale (82.4%, 17 deliveries) are
   dependable; Metro Parts Co and Sunbelt Distribution both sit at
   50.0%, and late deliveries run 3.3 to 6.5 days late depending on the
   supplier (QuickShip Logistics worst at 6.5 days average).
3. **A quarter of inventory value is in stock that stopped moving.** 6
   items are slow-moving, tying up $4,470.94 of the $16,862.52 total
   inventory value (26.5%). The largest single item is Standing Desk
   Frames: 3 units × $349.00 = $1,047.00, last sold 2026-05-03. Binder
   Clips are the volume case — 140 units ($880.60) unsold since June.
4. **Two items are on both problem lists.** Office Chairs and Standing
   Desk Frames are simultaneously at/below reorder point *and*
   slow-moving — the reorder rule is about to buy more of items that
   have not sold in five months.

## What this means

The reorder point is being used as a trigger without a demand check, and
supplier choice is not reflecting measured reliability. The catalog
splits cleanly: fast lines supplied by two reliable vendors, and a tail
of slow stock — much of it from the two least reliable suppliers — that
absorbs cash and shelf space.

## Recommendations

1. **Reorder the urgent consumables today, in the scorecard's order.**
   Ballpoint Pens, HDMI Cables, Disinfecting Wipes, and Whiteboard
   Markers are the working supplies closest to a stockout; start at the
   top of the reorder list (query 1), not alphabetically.
2. **Hold the two overlapping items.** Do not reorder Office Chairs or
   Standing Desk Frames on the strength of the reorder point alone.
   Review whether the reorder points for slow furniture lines should be
   lowered, and clear the existing $1,806.96 of stock first (returns to
   vendor, bundle, or discount).
3. **Put the scorecard in front of suppliers.** Share the on-time table
   with Metro Parts Co and Sunbelt Distribution (50.0%) and set an
   improvement expectation; shift discretionary volume toward Pacific
   Office Supply and GreatLakes Wholesale (85.0% / 82.4%) where the
   catalog overlaps.
4. **Add a days-late buffer for unreliable suppliers.** For QuickShip
   Logistics (6.5 days average late) and Sunbelt (6.2 days), order
   earlier or raise safety stock on their critical lines rather than
   discovering the delay at the stockout.
5. **Review slow-moving stock monthly, in dollars.** A standing
   slow-moving report (query 3) with the $4,470.94-style total keeps the
   tied-up cash visible and gives purchasing a stop-list before the
   next order cycle.

# Solution — Pai Zay Oo

> Rename to `SOLUTION.md` when you submit.

## Time spent

~3:40 hours

## Tasks completed

- A1: filter + search applied — returns all offers.
- A2: Wired up adding items to the actual persistent local cart storage
- A3: Wrapped with RefreshIndicator for pull-to-refresh functionality
- A4: Friendly empty state widget when offers list is empty
- S1: CartService cumulative cartTotal aggregates discounted prices accurately

## Bugs fixed

- B1: API sends co2_kg but initially the key was wrong "co2_saved_kg"
- B2: updating the item element reference in place within the `_offers` list using `.copyWith()`.
- B3: Cart total in `cart_service` uses original prices instead of discounted rescue prices.

## AI tools used
-"Gemini": use for all tasks except B1 and B3

## If I had more time
- If I have more time, add favourite button on offer_screen and persist and show favourite only filter on home.